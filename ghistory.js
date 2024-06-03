const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');
const os = require('os');

if(process.argv.length < 3){
   console.log("Missing Argument Name of USB \n Don't Forget to Mount");
   process.exit(1);

// const usbname = process.argv[2];
// console.log(usbName);
}
// Step 1: Get a list of all users on the system
try { 
    const usbName = process.argv[2];
    console.log(usbName);
    const userList = execSync('dscl . list /Users').toString().trim().split('\n').filter(Boolean);
    userList.forEach(username => {
        // Step 2: Locate Chrome and Safari history files for each user
        const chromeHistoryPath = path.join('/Users', username, 'Library', 'Application Support', 'Google', 'Chrome', 'Default', 'History');
        const safariHistoryPath = path.join('/Users', username, 'Library', 'Safari', 'History.db');
	const firefoxHistoryPath = path.join('/Users', username, 'Library', 'Application Support', 'Firefox', 'Profiles', '*' , 'places.sqlite');
        // Use sudo to check existence and copy files if needed
	    const sudoChromeCmd = `sudo -u ${username} [ -e "${chromeHistoryPath}" ] && echo 'exists' || echo 'not exists'`;
	    const sudoSafariCmd = `sudo -u ${username} [ -e "${safariHistoryPath}" ] && echo 'exists' || echo 'not exists'`;
	    const sudoFirefoxCmd = `sudo -u ${username} [ -e "${firefoxHistoryPath}" ] && echo 'exists' || echo 'not exists'`;
        
	try {
            const chromeResult = execSync(sudoChromeCmd, { stdio: 'pipe' }).toString().trim();
            const safariResult = execSync(sudoSafariCmd, { stdio: 'pipe' }).toString().trim();
	    const firefoxResult = execSync(sudoFirefoxCmd, {stdio: 'pipe' }).toString().trim();

            // Step 3: Copy History files to a USB drive
            const usbDrivePath = `/Volumes/${usbName}`; // Replace with your USB drive's name

            if (chromeResult === 'exists') {
                const chromeDestinationPath = path.join(usbDrivePath, `${username}_ChromeHistory`);
                execSync(`sudo cp "${chromeHistoryPath}" "${chromeDestinationPath}"`); // Copy Chrome history with sudo
                console.log(`Copied Chrome history for user ${username} to ${chromeDestinationPath}`);
            } else {
                console.log(`Chrome history not found for user ${username}`);
            }

            if (safariResult === 'exists') {
                const safariDestinationPath = path.join(usbDrivePath, `${username}_SafariHistory`);
                execSync(`sudo cp "${safariHistoryPath}" "${safariDestinationPath}"`); // Copy Safari history with sudo
                console.log(`Copied Safari history for user ${username} to ${safariDestinationPath}`);
            } else {
                console.log(`Safari history not found for user ${username}`);
            }
	    if (firefoxResult === 'exists'){
		const firefoxDestinationPath = path.join(usbDrivePath, `${username}_Firefox`);
                execSync(`sudo cp "${firefoxiHistoryPath}" "${firefoxDestinationPath}"`); // Copy Firefox history with sudo
                console.log(`Copied Firefox history for user ${username} to ${firefoxDestinationPath}`);
            } else {
                console.log(`Firefox history not found for user ${username}`);
            }
	    
        } catch (error) {
            console.error(`Error checking histories for user ${username}:`, error);
        }
    });
} catch (error) {
    console.error('Error:', error);
}
