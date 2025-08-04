```Terminal
py -3 -m venv .venv
```
This command is used to create the virtual environment required for python to manage packages.
Learn More: [12. Virtual Environments and Packages — Python 3.13.5 documentation](https://docs.python.org/3/tutorial/venv.html)

### Then we have to activate the virtual environment  (Git Bash).
```Bash
source .venv/Scripts/activate
```
If it's PowerShell then, the terminal command will be as follows:
```PowerShell
.venv/Scripts/activate
```

### To test the virtual environment is activated successfully:
```Bash
echo $VIRTUAL_ENV
```
This command will print a path of the virtual environment if it's activated successfully.

### Then we have to install DJango using the pip package installer:
```Bash
pip install django
```

To know the version of the Django:
```Bash
django-admin --version
```
### Now only we have to create the django project,
```Bash
django-admin startproject DjangoProject .
```
Or:
```Bash
django-admin startproject my-django-app .
```
Here a command line utility file (manage.py) along with the project files will be created.
The manage.py will be used to run django project related commands.

There would be some new files be created under the folder DjangoProject.

These are the core files that Django automatically creates when you start a new Django project. Here's the purpose of each:

## `__init__.py`
- **Purpose**: Makes the DjangoProject directory a Python package
- **Content**: Usually empty or contains package initialization code
- **Why it's needed**: Tells Python that this directory should be treated as a package, allowing you to import modules from it

## `settings.py`
- **Purpose**: Central configuration file for your Django project
- **Contains**:
  - Database configuration
  - Installed apps list
  - Middleware settings
  - Static files configuration
  - Security settings (SECRET_KEY, DEBUG mode)
  - Time zone and internationalization settings
  - Template engine configuration
- **Why it's important**: Controls how your entire Django application behaves

## `urls.py`
- **Purpose**: URL routing configuration (URL dispatcher)
- **Function**: Maps URLs to views
- **Contains**: URL patterns that tell Django which view function to call for each URL
- **Example**: When someone visits `/admin/`, this file determines what should happen
- **Think of it as**: The "table of contents" for your website's pages

## `asgi.py`
- **Purpose**: ASGI (Asynchronous Server Gateway Interface) configuration
- **Used for**: 
  - Asynchronous applications
  - WebSockets
  - HTTP/2
  - Real-time features
- **When to use**: For modern async web applications, chat applications, real-time notifications

## `wsgi.py`
- **Purpose**: WSGI (Web Server Gateway Interface) configuration
- **Used for**: 
  - Traditional synchronous web applications
  - Production deployment
  - Standard HTTP requests
- **When to use**: Most common for traditional web apps and production servers like Apache, Nginx + Gunicorn

**In summary**: `settings.py` configures your app, `urls.py` routes traffic, `wsgi.py`/`asgi.py` handle server communication, and `__init__.py` makes it all a proper Python package.

### Now we're good to run the django server.
```Terminal
python manage.py runserver
```

### Create Application
move to the directory where manage.py exists and ->
Terminal:
```Bash
python manage.py startapp my_django_app
```