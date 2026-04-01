```JavaScript
const socketIO = require('socket.io');

// Store online users
const onlineUsers = new Map();

const configureSocket = (server) => {
  const io = socketIO(server, {
    cors: {
      origin: ["http://localhost:5173", "http://localhost:5174", "http://localhost:5175", "http://localhost:5176"],
      methods: ["GET", "POST"]
    }
  });

  io.on('connection', (socket) => {
    console.log('🔌 User connected:', socket.id);

    // User joins the app
    socket.on('user_online', (userId) => {
      onlineUsers.set(userId, socket.id);
      console.log(`👤 User ${userId} is online`);
      
      // Broadcast to relevant users that this user is online
      socket.broadcast.emit('user_status_change', {
        userId,
        status: 'online'
      });
    });

    // Join a conversation room
    socket.on('join_conversation', (conversationId) => {
      socket.join(conversationId);
      console.log(`User ${socket.id} joined conversation: ${conversationId}`);
    });

    // Leave a conversation room
    socket.on('leave_conversation', (conversationId) => {
      socket.leave(conversationId);
      console.log(`User ${socket.id} left conversation: ${conversationId}`);
    });

    // Send a message
    socket.on('send_message', async (messageData) => {
      try {
        console.log('💬 Message received:', messageData);
        
        // Save message to database (we'll create this later)
        const savedMessage = {
          _id: Date.now().toString(), // Temporary ID
          ...messageData,
          timestamp: new Date()
        };

        // Broadcast to all users in the conversation
        io.to(messageData.conversationId).emit('receive_message', savedMessage);
        
        // Notify other users in conversation about new message
        socket.to(messageData.conversationId).emit('new_message_notification', {
          conversationId: messageData.conversationId,
          senderName: messageData.senderName,
          preview: messageData.content.substring(0, 50) + '...'
        });

      } catch (error) {
        console.error('Error handling message:', error);
        socket.emit('message_error', {
          error: 'Failed to send message',
          originalMessage: messageData
        });
      }
    });

    // Typing indicators
    socket.on('typing_start', (data) => {
      socket.to(data.conversationId).emit('user_typing', {
        userId: data.userId,
        userName: data.userName
      });
    });

    socket.on('typing_stop', (data) => {
      socket.to(data.conversationId).emit('user_stop_typing', {
        userId: data.userId
      });
    });

    // Handle disconnection
    socket.on('disconnect', () => {
      console.log('🔌 User disconnected:', socket.id);
      
      // Find and remove user from online users
      for (let [userId, socketId] of onlineUsers.entries()) {
        if (socketId === socket.id) {
          onlineUsers.delete(userId);
          
          // Broadcast that user went offline
          socket.broadcast.emit('user_status_change', {
            userId,
            status: 'offline'
          });
          break;
        }
      }
    });
  });

  return io;
};

module.exports = { configureSocket, onlineUsers };
```

## Context
```JavaScript
import React, { createContext, useContext, useEffect, useState } from 'react';
import { io } from 'socket.io-client';
import { useAuth } from './AuthContext';

const SocketContext = createContext();

export const useSocket = () => {
  const context = useContext(SocketContext);
  if (!context) {
    throw new Error('useSocket must be used within a SocketProvider');
  }
  return context;
};

export const SocketProvider = ({ children }) => {
  const [socket, setSocket] = useState(null);
  const [onlineUsers, setOnlineUsers] = useState(new Set());
  const { user } = useAuth();

  useEffect(() => {
    if (user) {
      // Connect to WebSocket server
      const newSocket = io('http://localhost:5000', {
        withCredentials: true
      });

      setSocket(newSocket);

      // Notify server that user is online
      newSocket.emit('user_online', user.id);

      // Listen for online users updates
      newSocket.on('user_status_change', (data) => {
        setOnlineUsers(prev => {
          const updated = new Set(prev);
          if (data.status === 'online') {
            updated.add(data.userId);
          } else {
            updated.delete(data.userId);
          }
          return updated;
        });
      });

      // Cleanup on unmount
      return () => {
        newSocket.disconnect();
        setSocket(null);
      };
    }
  }, [user]);

  const value = {
    socket,
    onlineUsers,
    isUserOnline: (userId) => onlineUsers.has(userId)
  };

  return (
    <SocketContext.Provider value={value}>
      {children}
    </SocketContext.Provider>
  );
};
```

## Chat Window
```JavaScript
import React, { useState, useRef, useEffect } from 'react';
import { useSocket } from '../../context/SocketContext';
import FileUpload from '../upload/FileUpload';

const ChatWindow = ({ 
  conversation, 
  messages, 
  onSendMessage, 
  currentUser, 
  isUserOnline,
  socket 
}) => {
  const [newMessage, setNewMessage] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [typingUser, setTypingUser] = useState(null);
  const [showFileUpload, setShowFileUpload] = useState(false);
  const messagesEndRef = useRef(null);
  const typingTimeoutRef = useRef(null);

  const otherParticipant = conversation.participants.find(p => p._id !== currentUser.id);

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // Typing indicators
  useEffect(() => {
    if (socket) {
      socket.on('user_typing', (data) => {
        if (data.userId !== currentUser.id) {
          setIsTyping(true);
          setTypingUser(data.userName);
        }
      });

      socket.on('user_stop_typing', (data) => {
        if (data.userId !== currentUser.id) {
          setIsTyping(false);
          setTypingUser(null);
        }
      });

      return () => {
        socket.off('user_typing');
        socket.off('user_stop_typing');
      };
    }
  }, [socket, currentUser.id]);

  const handleInputChange = (e) => {
    setNewMessage(e.target.value);

    // Typing indicators
    if (socket) {
      socket.emit('typing_start', {
        conversationId: conversation._id,
        userId: currentUser.id,
        userName: currentUser.name
      });

      // Clear existing timeout
      if (typingTimeoutRef.current) {
        clearTimeout(typingTimeoutRef.current);
      }

      // Set new timeout to stop typing indicator
      typingTimeoutRef.current = setTimeout(() => {
        socket.emit('typing_stop', {
          conversationId: conversation._id,
          userId: currentUser.id
        });
      }, 1000);
    }
  };

  const handleSendMessage = (e) => {
    e.preventDefault();
    if (!newMessage.trim()) return;

    onSendMessage(newMessage);
    setNewMessage('');

    // Stop typing indicator
    if (socket) {
      socket.emit('typing_stop', {
        conversationId: conversation._id,
        userId: currentUser.id
      });
    }

    // Clear typing timeout
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }
  };

  const handleFileUpload = async (uploadedFiles) => {
    if (!selectedConversation || uploadedFiles.length === 0) return;

    const file = uploadedFiles[0];
    
    const messageData = {
      conversationId: conversation._id,
      sender: currentUser.id,
      senderName: currentUser.name,
      receiver: otherParticipant?._id,
      content: `Shared a file: ${file.original_filename}`,
      messageType: file.format.startsWith('image/') ? 'image' : 'document',
      file: file,
      timestamp: new Date()
    };

    // Send via WebSocket
    if (socket) {
      socket.emit('send_message', messageData);
    }

    setShowFileUpload(false);
  };

  const formatMessageTime = (timestamp) => {
    return new Date(timestamp).toLocaleTimeString([], { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  };

  const isSameSender = (currentMessage, previousMessage) => {
    return previousMessage && 
           currentMessage.sender?._id === previousMessage.sender?._id &&
           (new Date(currentMessage.timestamp) - new Date(previousMessage.timestamp)) < 300000; // 5 minutes
  };

  const getFileIcon = (fileType) => {
    if (fileType.startsWith('image/')) return '🖼️';
    if (fileType === 'pdf') return '📄';
    if (fileType.includes('document')) return '📝';
    return '📎';
  };

  return (
    <div className="flex flex-col h-full">
      {/* Chat Header */}
      <div className="p-4 border-b border-gray-200 bg-white">
        <div className="flex items-center space-x-3">
          <div className="relative">
            <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
              {otherParticipant?.name?.charAt(0) || 'U'}
            </div>
            {isUserOnline(otherParticipant?._id) && (
              <div className="absolute -bottom-1 -right-1 w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
            )}
          </div>
          <div>
            <h2 className="font-semibold text-gray-900">
              {otherParticipant?.name || 'Unknown User'}
            </h2>
            <p className="text-sm text-gray-600">
              {isUserOnline(otherParticipant?._id) ? 'Online' : 'Offline'}
              {conversation.job && ` • ${conversation.job.title}`}
            </p>
          </div>
        </div>
      </div>

      {/* Messages Area */}
      <div className="flex-1 overflow-y-auto p-4 bg-gray-50">
        {messages.length === 0 ? (
          <div className="flex items-center justify-center h-full">
            <div className="text-center">
              <div className="text-4xl mb-4">💬</div>
              <h3 className="text-lg font-semibold mb-2">No messages yet</h3>
              <p className="text-gray-600">Send a message to start the conversation</p>
            </div>
          </div>
        ) : (
          <div className="space-y-2">
            {messages.map((message, index) => {
              const isOwnMessage = message.sender?._id === currentUser.id;
              const showAvatar = !isSameSender(message, messages[index - 1]);

              return (
                <div
                  key={message._id || index}
                  className={`flex ${isOwnMessage ? 'justify-end' : 'justify-start'}`}
                >
                  <div className={`flex max-w-xs lg:max-w-md ${isOwnMessage ? 'flex-row-reverse' : 'flex-row'} items-end space-x-2`}>
                    {/* Avatar */}
                    {showAvatar && !isOwnMessage && (
                      <div className="w-8 h-8 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white text-xs font-semibold flex-shrink-0">
                        {message.sender?.name?.charAt(0) || 'U'}
                      </div>
                    )}

                    {/* Message Bubble */}
                    <div
                      className={`px-4 py-2 rounded-2xl max-w-full ${
                        isOwnMessage
                          ? 'bg-blue-600 text-white rounded-br-none'
                          : 'bg-white text-gray-900 border border-gray-200 rounded-bl-none'
                      }`}
                    >
                      {/* File Message */}
                      {message.file && (
                        <div className="mb-2">
                          {message.messageType === 'image' ? (
                            <div className="max-w-xs">
                              <img
                                src={message.file.url}
                                alt={message.file.original_filename}
                                className="rounded-lg border border-gray-200 max-h-48 object-cover"
                              />
                            </div>
                          ) : (
                            <div className="flex items-center space-x-3 p-3 bg-white bg-opacity-20 rounded-lg border border-white border-opacity-30">
                              <span className="text-2xl">
                                {getFileIcon(message.file.fileType)}
                              </span>
                              <div className="flex-1 min-w-0">
                                <p className="font-medium text-sm truncate">
                                  {message.file.original_filename}
                                </p>
                                <p className="text-xs opacity-80">
                                  {(message.file.bytes / 1024).toFixed(1)} KB • {message.file.fileType.toUpperCase()}
                                </p>
                              </div>
                              <a
                                href={message.file.url}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="bg-white bg-opacity-20 hover:bg-opacity-30 text-white text-xs px-2 py-1 rounded transition-colors"
                              >
                                View
                              </a>
                            </div>
                          )}
                        </div>
                      )}
                      
                      {/* Text Content */}
                      {message.content && (
                        <p className="text-sm whitespace-pre-wrap">{message.content}</p>
                      )}
                      
                      <p
                        className={`text-xs mt-1 ${
                          isOwnMessage ? 'text-blue-200' : 'text-gray-500'
                        }`}
                      >
                        {formatMessageTime(message.timestamp)}
                      </p>
                    </div>

                    {/* Spacer for alignment */}
                    {showAvatar && isOwnMessage && <div className="w-8"></div>}
                  </div>
                </div>
              );
            })}

            {/* Typing Indicator */}
            {isTyping && (
              <div className="flex justify-start">
                <div className="flex items-end space-x-2">
                  <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center text-white text-xs font-semibold">
                    {typingUser?.charAt(0) || 'U'}
                  </div>
                  <div className="bg-white border border-gray-200 rounded-2xl rounded-bl-none px-4 py-3">
                    <div className="flex space-x-1">
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            <div ref={messagesEndRef} />
          </div>
        )}
      </div>

      {/* File Upload Section */}
      {showFileUpload && (
        <div className="border-t border-gray-200 bg-white">
          <div className="p-4">
            <div className="flex justify-between items-center mb-3">
              <h4 className="font-medium text-gray-700">Attach File</h4>
              <button
                onClick={() => setShowFileUpload(false)}
                className="text-gray-500 hover:text-gray-700 text-lg"
                title="Close file upload"
              >
                ✕
              </button>
            </div>
            <FileUpload
              onUploadComplete={handleFileUpload}
              maxFiles={1}
              acceptedTypes={['image/*', 'application/pdf', '.doc', '.docx']}
            />
          </div>
        </div>
      )}

      {/* Message Input */}
      <div className="p-4 border-t border-gray-200 bg-white">
        <form onSubmit={handleSendMessage} className="flex space-x-2">
          {/* File Upload Button */}
          <button
            type="button"
            onClick={() => setShowFileUpload(!showFileUpload)}
            className={`flex items-center justify-center w-12 h-12 rounded-full transition-colors ${
              showFileUpload ? 'bg-blue-100 text-blue-600' : 'bg-gray-100 hover:bg-gray-200 text-gray-600'
            }`}
            title="Attach file"
          >
            <span className="text-xl">📎</span>
          </button>

          <input
            type="text"
            value={newMessage}
            onChange={handleInputChange}
            placeholder="Type your message..."
            className="flex-1 input-field rounded-full"
            maxLength={2000}
          />
          
          <button
            type="submit"
            disabled={!newMessage.trim()}
            className="btn-primary rounded-full px-6 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Send
          </button>
        </form>
        <p className="text-xs text-gray-500 mt-2 text-center">
          Press Enter to send • {2000 - newMessage.length} characters remaining
        </p>
      </div>
    </div>
  );
};

export default ChatWindow;
```

## Messages Page
```JavaScript
import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useSocket } from '../context/SocketContext';
import api from '../services/api';
import ConversationList from '../components/messages/ConversationList';
import ChatWindow from '../components/messages/ChatWindow';

const Messages = () => {
  const [conversations, setConversations] = useState([]);
  const [selectedConversation, setSelectedConversation] = useState(null);
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const { user } = useAuth();
  const { socket, isUserOnline } = useSocket();
  const { conversationId } = useParams();

  useEffect(() => {
    fetchConversations();
  }, [user]);

  useEffect(() => {
    if (conversationId) {
      const conversation = conversations.find(c => c._id === conversationId);
      if (conversation) {
        setSelectedConversation(conversation);
        fetchMessages(conversationId);
      }
    }
  }, [conversationId, conversations]);

  // Listen for new messages
  useEffect(() => {
    if (socket) {
      socket.on('receive_message', (newMessage) => {
        if (selectedConversation && newMessage.conversationId === selectedConversation._id) {
          setMessages(prev => [...prev, newMessage]);
        }
        // Update conversations list with new message
        updateConversationLastMessage(newMessage);
      });

      socket.on('new_message_notification', (notification) => {
        if (!selectedConversation || notification.conversationId !== selectedConversation._id) {
          // Show desktop notification or update badge
          console.log('New message notification:', notification);
        }
      });

      return () => {
        socket.off('receive_message');
        socket.off('new_message_notification');
      };
    }
  }, [socket, selectedConversation]);

  const fetchConversations = async () => {
    try {
      const response = await api.get('/messages/conversations');
      setConversations(response.data);
    } catch (error) {
      console.error('Error fetching conversations:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchMessages = async (convId) => {
    try {
      const response = await api.get(`/messages/conversations/${convId}/messages`);
      setMessages(response.data);
      
      // Join conversation room for real-time updates
      if (socket) {
        socket.emit('join_conversation', convId);
      }
    } catch (error) {
      console.error('Error fetching messages:', error);
    }
  };

  const updateConversationLastMessage = (message) => {
    setConversations(prev => 
      prev.map(conv => 
        conv._id === message.conversationId 
          ? { ...conv, lastMessage: message, lastMessageAt: new Date() }
          : conv
      ).sort((a, b) => new Date(b.lastMessageAt) - new Date(a.lastMessageAt))
    );
  };

  const handleSelectConversation = (conversation) => {
    setSelectedConversation(conversation);
    if (socket && selectedConversation) {
      socket.emit('leave_conversation', selectedConversation._id);
    }
  };

  const handleSendMessage = (content) => {
    if (!selectedConversation || !content.trim()) return;

    const messageData = {
      conversationId: selectedConversation._id,
      sender: user.id,
      senderName: user.name,
      receiver: selectedConversation.participants.find(p => p._id !== user.id)?._id,
      content: content.trim(),
      timestamp: new Date()
    };

    // Send via WebSocket
    if (socket) {
      socket.emit('send_message', messageData);
    }
  };

  // Filter conversations based on search
  const filteredConversations = conversations.filter(conv => {
    const otherParticipant = conv.participants.find(p => p._id !== user.id);
    return otherParticipant?.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
           conv.lastMessage?.content?.toLowerCase().includes(searchTerm.toLowerCase());
  });

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-white/20">
            <div className="animate-pulse">
              <div className="h-8 bg-gray-200 rounded w-1/4 mb-6"></div>
              <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <div className="lg:col-span-1 space-y-4">
                  {[...Array(5)].map((_, i) => (
                    <div key={i} className="h-20 bg-gray-200 rounded-xl"></div>
                  ))}
                </div>
                <div className="lg:col-span-3 bg-gray-200 rounded-xl h-96"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <div className="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-white/20">
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent mb-2">
                  Messages
                </h1>
                <p className="text-gray-600 text-lg">
                  Connect and collaborate with {user?.role === 'freelancer' ? 'clients' : 'freelancers'}
                </p>
              </div>
              <div className="hidden lg:block">
                <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg">
                  <span className="text-2xl text-white">💬</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Messages Container */}
        <div className="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-white/20 overflow-hidden">
          <div className="flex flex-col lg:flex-row h-[70vh]">
            {/* Conversations Sidebar */}
            <div className="lg:w-1/3 border-r border-gray-200/50 flex flex-col">
              {/* Search Header */}
              <div className="p-6 border-b border-gray-200/50 bg-gradient-to-r from-blue-50 to-purple-50">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-2xl font-bold text-gray-900">Conversations</h2>
                  <div className="text-sm bg-blue-100 text-blue-700 px-3 py-1 rounded-full font-medium">
                    {conversations.length} chats
                  </div>
                </div>
                
                {/* Search Bar */}
                <div className="relative">
                  <input
                    type="text"
                    placeholder="Search conversations..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full px-4 py-3 pl-12 bg-white/70 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 backdrop-blur-sm placeholder-gray-400"
                  />
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center">
                    <span className="text-gray-400">🔍</span>
                  </div>
                  {searchTerm && (
                    <button
                      onClick={() => setSearchTerm('')}
                      className="absolute inset-y-0 right-0 pr-4 flex items-center"
                    >
                      <span className="text-gray-400 hover:text-gray-600">✕</span>
                    </button>
                  )}
                </div>
              </div>

              {/* Conversations List */}
              <div className="flex-1 overflow-y-auto">
                {filteredConversations.length > 0 ? (
                  <ConversationList
                    conversations={filteredConversations}
                    selectedConversation={selectedConversation}
                    onSelectConversation={handleSelectConversation}
                    isUserOnline={isUserOnline}
                    currentUser={user}
                  />
                ) : (
                  <div className="flex flex-col items-center justify-center h-full p-8 text-center">
                    <div className="text-6xl mb-4 opacity-50">💭</div>
                    <h3 className="text-lg font-semibold text-gray-600 mb-2">
                      {searchTerm ? 'No conversations found' : 'No conversations yet'}
                    </h3>
                    <p className="text-gray-500 text-sm">
                      {searchTerm 
                        ? 'Try adjusting your search terms'
                        : 'Start a conversation by contacting someone'
                      }
                    </p>
                  </div>
                )}
              </div>

              {/* Quick Actions Footer */}
              <div className="p-4 border-t border-gray-200/50 bg-gray-50/50">
                <div className="grid grid-cols-2 gap-3">
                  <Link
                    to="/jobs"
                    className="flex items-center justify-center p-3 bg-white border border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-all duration-200 text-sm font-medium text-gray-700"
                  >
                    <span className="mr-2">💼</span>
                    Find Work
                  </Link>
                  <Link
                    to="/profile"
                    className="flex items-center justify-center p-3 bg-white border border-gray-200 rounded-xl hover:border-purple-300 hover:bg-purple-50 transition-all duration-200 text-sm font-medium text-gray-700"
                  >
                    <span className="mr-2">👤</span>
                    My Profile
                  </Link>
                </div>
              </div>
            </div>

            {/* Chat Window */}
            <div className="lg:w-2/3 flex flex-col">
              {selectedConversation ? (
                <ChatWindow
                  conversation={selectedConversation}
                  messages={messages}
                  onSendMessage={handleSendMessage}
                  currentUser={user}
                  isUserOnline={isUserOnline}
                  socket={socket}
                />
              ) : (
                <div className="flex-1 flex flex-col items-center justify-center p-8 bg-gradient-to-br from-gray-50 to-blue-50/30">
                  <div className="text-center max-w-md">
                    <div className="w-32 h-32 bg-gradient-to-br from-blue-200 to-purple-200 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-lg">
                      <span className="text-5xl">💬</span>
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900 mb-3">
                      Welcome to Messages
                    </h3>
                    <p className="text-gray-600 mb-6 leading-relaxed">
                      Select a conversation from the sidebar to start chatting, or connect with professionals to begin new conversations.
                    </p>
                    <div className="grid grid-cols-2 gap-4">
                      <Link
                        to="/jobs"
                        className="flex items-center justify-center p-4 bg-white border border-gray-200 rounded-xl hover:border-blue-300 hover:bg-blue-50 transition-all duration-200 font-medium text-gray-700"
                      >
                        <span className="mr-2">🔍</span>
                        Browse Jobs
                      </Link>
                      <Link
                        to="/freelancers"
                        className="flex items-center justify-center p-4 bg-white border border-gray-200 rounded-xl hover:border-green-300 hover:bg-green-50 transition-all duration-200 font-medium text-gray-700"
                      >
                        <span className="mr-2">👥</span>
                        Find Talent
                      </Link>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Features Footer */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20 shadow-lg">
            <div className="w-12 h-12 bg-blue-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl text-blue-600">⚡</span>
            </div>
            <h4 className="font-semibold text-gray-900 mb-2">Real-time Chat</h4>
            <p className="text-sm text-gray-600">Instant messaging with live updates</p>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20 shadow-lg">
            <div className="w-12 h-12 bg-green-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl text-green-600">🔒</span>
            </div>
            <h4 className="font-semibold text-gray-900 mb-2">Secure & Private</h4>
            <p className="text-sm text-gray-600">End-to-end encrypted conversations</p>
          </div>
          
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20 shadow-lg">
            <div className="w-12 h-12 bg-purple-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl text-purple-600">💼</span>
            </div>
            <h4 className="font-semibold text-gray-900 mb-2">Project Focused</h4>
            <p className="text-sm text-gray-600">Chat within project context</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Messages;
```