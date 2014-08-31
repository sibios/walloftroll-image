Wall of Troll
=============

Image Troll
-----------
Used for Wall of Sheep instances where targeted traffic is HTTP requests for image files (jpg,png,gif).  Relevant components are:

- Client: the mandatory component that must run on a machine associated with the WoS'd network.  Can run in independent and server-backed mode.

- Server (optional): used with client running in server-backed mode.  The server application is a small Sinatra web applicaiton that will provide randomization and cache-evasion features to the client.
