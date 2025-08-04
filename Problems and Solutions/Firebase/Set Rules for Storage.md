
```(CEL)-Common-Expression-Language 

rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isValidImage() {
      return request.resource.contentType.matches('image/.*')
        && request.resource.size < 5 * 1024 * 1024; // 5MB limit
    }
    
    function isOwner(userId) {
      return isAuthenticated() 
        && request.auth.uid == userId;
    }

    match /{userId}/listings/images/{imageId} {
      
      //Public (anyone can view listing images)
      allow read;
      
      //Only listing owners can upload images
      allow write: if isAuthenticated()
        && isValidImage()
        && isOwner(userId);
      
      //Only listing owners can delete images
      allow delete: if isAuthenticated()
        && isOwner(userId);
    }
  }
}

```
