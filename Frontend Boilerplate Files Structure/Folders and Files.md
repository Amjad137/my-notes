1. Delete unwanted files and clean up things.
2. Create the following folders in the src directory
		components
			pages
			shared (common components will be here)
			shared/ui (should be created by shadcn, if not adjust the components.json file)
		config (configurations will be here (eg: [[env.config.ts]]))
		constants (eg: [[common.constants.ts]])
		styles ([[global.css]] should be moved here)
		types (enums,types and interface will be here)
		utils (eg: [[tailwind-utils.ts]])
		[[version.ts]]
3. Create following files in the project directory
		[['.env.development']]
		[['.env.production']]
		[['.env.local']]
		[['.prettierrc]]
		[['.eslintrc]]
		[['.prettierignore]]
		[['.yarnrc.yml]]

![[Pasted image 20240504091149.png]]
![[Pasted image 20240504091232.png]]