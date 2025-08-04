
1. Microsoft OAuth APIs
	- /auth/microsoft-login/initiate (POST)
	- /auth/microsoft-login/callback (POST)
	- /auth/logout (POST)
	  
	  
2. User Management
	- /users (GET) - Get All Users
		- Params:
			- status: Active, Deactivated, Archived, Cancelled and Invited
			- filtration related params like sort_by or order_by would be added
	- /users/:id (GET) - Get User by ID
	- /users (POST) - Add New User/s
		- Request Body:
			- Name
			- Email
			- User Role
			- profilePicUrl
			- Contact Number (to be clarified)
	- /users/:id (PATCH) - Update User by ID
		- Request Body:
			- Name
			- Email
			- User Role
			- profilePicUrl
			- Contact Number (to be clarified)
			  

3. Invitation Management
	- /invitations/send (POST)
		- Request Body:
			- Name
			- Email
			- User Role
			- Contact Number
	- /invitations/verify (GET)
		- Params:
			- token (probably)
			  
			  
4. Off Takers
	- /off-takers (GET) - Get All Off Takers
	- /off-takers/:id (GET) - Get Off Taker by ID
	- /off-taker (POST) - Create Off taker
		- Request Body:
			- Name
			- Email
			- Phone
			- Street Address
			- City
			- State
			- Zip
			- Region
			- Country (to be clarified)
	- /off-taker (POST) - Update Off taker
		- Request Body:
			- Name
			- Email
			- Phone
			- Street Address
			- City
			- State
			- Zip
			- Region
			- Country (to be clarified)
			  
			  
5. Tranches
	- /tranches (GET) - Get All Tranches
	- /tranches/:id (GET) - Get Tranche by ID
	- /tranches (POST) - Create Tranche
		- Request Body:
			- Name
			- Tranche Owner
			- Phone
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
	- /tranches (PATCH) - Update Tranche
		- Request Body:
			- Name
			- Tranche Owner
			- Phone
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
			  

6. Device Management
	- /devices (GET) - Get All Devices
		- Params:
			- status?: (online, offline)
			- projectID?:
			- siteID?:
			- manufacturer?: (egauge, enphase)
			-  filtration related params like sort_by or order_by would be added
	- /devices/{device_id} (GET) - Get Device Details by ID
	- /devices (POST) - Add Device
		- Request Body:
			- Manufacturer: (egauge, enphase)
			- siteID
			- projectID
			- Props Res ID/ Meter Name
			- Device Name
			- User Name
			- Password?: (Not applicable if the selected manufacturer is "Enphase")
			- Custom Frequency?:[{name, startTime, endTime}]
	- /devices/{device_id} (PATCH) - Add Device
		- Request Body:
			- Manufacturer: (egauge, enphase)
			- siteID
			- projectID
			- Props Res ID/ Meter Name
			- Device Name
			- User Name
			- Password?: (Not applicable if the selected manufacturer is "Enphase")
		 //device addition status?
		 

7. Site Management
	- /sites (GET) - Get All Site Details
	- /sites/{site_id} (GET) - Get a Single Site Details
	- /sites (POST) - Create Sites
		- Request Body:
			- Site Name
			- Contact Number
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
			- Devices: [Obj IDs of Devices]
	- /sites/{site_id} (PATCH) - Update Site Details
		- Request Body:
			- Site Name
			- Contact Number
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
			- Devices: [Obj IDs of Devices]
	- /sites/{site_id}/history (GET) - View Site Edit History

	Site Bill Details
	- /sites/{site_id}/bills (GET) - Get Billing details of the site
		- Params:
			- Billing Period?:
			- Status: (Pending, Approved)
	- /sites/{site_id}/bills/{bill_id} (GET) - Get Detailed Bill details of the site
	- /sites/{site_id}/bills/{bill_id} (PATCH) - Adjust/Update Bill details of the site
		- Request Body:
			- Estimated Reading Value?:
	- /sites/{site_id}/bills/{bill_id}/errors (GET) - Get Error Logs for Billing Details
		- Params:
			- Off Taker?:
			- Date range: (All, Last 15 days, Last 7 Days)
	- /sites/{site_id}/bills/logs (GET) - Get Activity Logs of a Site's Bill (To be Clarified)
	  

8. Projects Management
	- /projects (GET) - Get All Projects
		- Params:
			- filtration related params like sort_by or order_by would be added
	- /projects/{project_id} (GET) - Get Project Details by ID
		- Params:
			- filtration related params like sort_by or order_by would be added
	- /projects (POST) - Add New Project
		- Request Body:
			- Project Type: (Residential , Commercial)
			- Project Name
			- Contact Number
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
			- System Size (to be clarified)
			- Tranches: [{Obj ID of Tranche, Start Date, End Date, Related Docs Urls (Optional) }]
			- Off Takers: [{Obj ID of Off-Taker, Start Date, End Date}]
	- /projects/{project_id}  (PATCH) - Update Project
		- Request Body:
			- Project Type: (Residential , Commercial)
			- Project Name
			- Contact Number
			- Email
			- Street Address
			- City
			- State
			- Zip
			- Region
			- System Size (to be clarified)
			- Sites: [Obj IDs of Sites]
			- Tranches: [{Obj ID of Tranche, Start Date, End Date, Related Docs Urls (Optional) }]
			- Off Takers: [{Obj ID of Off-Taker, Start Date, End Date}]
	- /projects/{project_id}/history (GET) - View Project's Edit History Log

	Project Bill Details
	- /projects/{project_id}/bills (GET) - Get Billing details of the project
		- Params:
			- Billing Period?:
			- Status: (Pending, Approved)
	- /projects/{project_id}/bills/{bill_id} (GET) - Get Detailed Bill details of the project
	- /projects/{project_id}/bills/{bill_id} (PATCH) - Adjust/Update Bill details of the project
		- Request Body:
			- Estimated Reading Value?:
	- /projects/{project_id}/bills/{bill_id}/errors (GET) - Get Error Logs for Billing Details
		- Params:
			- Off Taker?:
			- Date range: (All, Last 15 days, Last 7 Days)
	- /projects/{project_id}/bills/logs (GET) - Get Activity Logs of a Project's Bill (To be Clarified)
