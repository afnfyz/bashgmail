# BashGmail

### This script will allow you to send emails from the terminal after you have set up a project on google cloud and have enabled gmail's api.
Once you provision the script with a refresh token, your client ID and client secret, it is ready to be used.


#### To send emails go through these steps:
- Edit the email_body.txt file with the message you want to send.
<img width="596" alt="email_body" src="https://user-images.githubusercontent.com/124072294/223895350-5f5fc59e-4151-4a3b-a304-0687527a8f16.png">

- Open the script and edit the subject of the email to your liking and choose the source and the destination email(s).  
<img width="794" alt="et_var" src="https://user-images.githubusercontent.com/124072294/223896639-7dd66831-afd2-4c49-97ca-4e73a672967d.png">

- Then you can run the script.

#### Note: This script requires jq to be installed. 

On Mac OS run <code> brew install jq </code>
<img width="1118" alt="Mac_jq" src="https://user-images.githubusercontent.com/124072294/223886205-13576cf2-17dc-46c7-b6cd-7174dbe51cff.png">

On Ubuntu run code <code> sudo apt install jq </code>
<img width="1074" alt="Ubuntu_jq" src="https://user-images.githubusercontent.com/124072294/223886231-6df5c3cc-05ad-4d4b-8701-c0636d7e51a5.png">

