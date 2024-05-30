# Ansible Technical Challenge
# Prerequisites
1. Ansible installed in your system
2. python3 is installed in your system
3. boto3 is installed in your system
4. AWS cli is installed and you have the aws login credentials to a user with ec2 and VPC administration permission
5. Clone the git repo
6. navigate inside the repo
7. Create a vault file inside group_vars folder and name it aws_credentials.yml and fill it with your aws access and secret key. Example below
   ansible-vault create group_vars/aws_credentials.yml (You'll be asked for a password)
   Enter Password:
   Confirm Password:
   aws_access_key: "Your access key"
   aws_secret_key: "Your secret key:
   :wq!
8. Create a new file named vault_pass.txt in ~/.ansible/ folder and enter the password you used to create the vault file. You can store it elsewhere but please specify/change the location in ansible.cfg file under "vault_password_file"
   vault_password_file: /file/location/filename.txt
9. Run ansible-galaxy collection install -r collections/requirements.yml
10. Run ansible-playbook site.yml
11. Once the playbook run is completed, access the sites using public IPs of both devices. One server is for Memory game and another is ant colony.

# Key points to remember:
Please make sure you delete the ssh key file from both aws and ansible-challenge folder if you have to re run the playbook. Also, please make sure you delete your resources once you've completed testing the playbook.
This playbook has been tested using macbook and is completely functional
