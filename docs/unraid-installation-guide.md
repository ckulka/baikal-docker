# Unraid Docker Baikal Installation

**I have added a Baikal docker container template within Unraid. See the community apps section within your Unraid Server for easier installation.**
**The template version uses the same docker container developed and maintained by @chulka and is merely a template to get it easily installed**

If you would like to roll your own installation straight from docker hub please continue

This Unraid Docker Installation guide will mostly assume a few things;
1.	You have docker enabled within Unraid

2.	You have enabled community apps within Unraid

3.	You have enabled within settings the ability to utilize dockerhub for search results (see settings within apps tab)

4.	_OPTIONAL - You have a reverse proxy container and network to allow for certificate handling & SSL connections_

**Installation Note** – You can change the tag within the repo in the later steps to one that is suitable for your setup. See here for further https://github.com/ckulka/baikal-docker

**Further installation Note** – If you’re choosing to utilise an external database such as mariadb, please ensure that you set this up correctly in that a database and user are all created as well as the network both Baikal and the mysql database are on in order for Baikal to connect and function correctly.

With that in mind, the installation of Baikal is rather simple once you have the above setup.

5.	Head over to apps and search for Baikal

6.	Click to begin the installation of Baikal within the search result. (_The repo is ckulka/baikal_)

7.	Set the toggle on the right in the template as ‘advanced view’ (_It defaults to basic view_)

8.	Check that your satified with the tag that is being placed within your docker repo line to ensure your pulling the right version that you want. See here for further tags and their update history https://hub.docker.com/r/ckulka/baikal/tags?page=1&ordering=last_updated

9.	Set your ‘Icon URL’ as https://raw.githubusercontent.com/sabre-io/sabre.io/master/source/img/baikal.png (_This will provide you with the Baikal logo_)

10.	Set your ‘WebUI’ as http://[IP]:[PORT:80]/ (_This could be changed to whatever suits your local server port requirements - see below_)

11.	Set ‘Extra Parameters’ as --restart=always

12.	Set your network type as needed (_OPTIONAL - Set network type as your network that you utilize for your SSL certs (for me its proxnetwork)._)

13.	Add in your static IP address that you will utilize for Baikal. (_It makes it easier to get to your hosted instance_)

14.	Add in a ‘path’ as;
*	Name – Config
*	Container Path - /var/www/baikal/config
*	Host Path - /mnt/user/appdata/baikal/config (_this could be changed to whatever suits your local server path requirements if your appdata path is different_)
*	Default Value - /mnt/user/appdata/baikal/config (_see above_)
*	Acccess Mode – Read/Write
*	Description – Container Path: /var/www/baikal/config

15.	Add in a ‘path’ as;
*	Name – Specific
*	Container Path - /var/www/baikal/Specific
*	Host Path - /mnt/user/appdata/baikal/specific (_this could be changed to whatever suits your local server path requirements if your appdata path is different_)
*	Default Value - /mnt/user/appdata/baikal/specific (_see above_)
*	Acccess Mode – Read/Write
*	Description – Container Path: /var/www/baikal/Specific

16.	Now add in a ‘port’ as;
*	Name – Port
*	Container Port – 80
*	Host Port – 80 (_this could be changed to whatever suits your local server port requirements if your 80 is already in use_)
*	Default Value – 80 (_this could be changed to whatever suits your local server port requirements - as above_)
*	Connection Type – TCP
*	Description – Container Port: 80

17.	Click apply to download/install the container.

20.	Start your Baikal docker container

21.	_OPTIONAL – Head over to your SSL cert provider container of choice and set-up as necessary to server certs to your Baikal instance for your domain._

22.	Head over to your webUI or domain and start the admin creation process.

23.	You have the choice within the steps to utilise the sqlite database or an external mysql (_such as mariadb_). Just make sure your mysql database is on the same network as your Baikal server so you can easily access it. If your choosing to go the mysql method like I did you will need to conduct further setup within the mysql docker/installation in order for Baikal to function correctly.
