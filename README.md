# Animal Jam 🐋🐴🐒
Interactive Animal 3D Model Viewer! It's a jam with animals! Check out my [blog posts](https://jakasaurusrex.github.io/CakeBlog/) to learn more about it! 

***

## Repo Organization
Because Processing and Arudino IDE require the files to be in projects with the same name as the file, the repository is a little confusing. The AnimalJam repository is the directory with all of the code, including the Processing pde file. Inside of this folder is a subfolder containing the Arduino code that runs on the ESP. Additionally, there is a data folder with all of the 3D models and textures I used in my project!

There is also a folder in the root directory containing the stl files for the enclosure! There is one stl for the top piece and one for the bottom piece that are connected with a screw!

## The final product!!

https://github.com/user-attachments/assets/d0af194a-caa4-4f50-9c3e-f8f28727a78c

## What is this? 🎨

For our second module in Creative Embedded Systems, our class was tasked to create interactive display using our ESP32s to serial write user input with Joysticks, Buttons and Potentiometers and Processing's ability to serial read to use the user input in an interesting way! The goal of my interactive display was to create a fun and silly interactive 3D model viewer to let you customize your own low poly animal scene. I also created a controller that housed the ESP32 so that it was easy and seamless to plug and play with any computer running processing!

Here are some of the tools and materials that I used to create the project and what you would need to replicate it:  
- ESP32 TTGO T-display + USB-C Cable
- Button, Joystick, and Potentiometer
- 3D Printer
- Soldering Iron and many M-F and M-M cables!
- Arudino + Processing IDEs
- Aseprite for the pixel art!
- Blender for 3D models!

## How to Build 🔨
1. Clone the repo!
```bash
git clone https://github.com/JakasaurusRex/AnimalJam.git
```
2. Download the STL files and start your 3D print! Adjust the sizes of the holes if necessary to fit your different sized joysticsk, buttons or potentiometer
3. Setup your circuit with your ESP32 on a breadboard as explained later!
4. Open then .ino file in arudino folder in your Arudino IDE and upload it to your connected ESP32 with the circuit setup - ensure that all the connections are working using the serial monitor.
5. Open up the processing file and try to run Animal Jam. Ensure that all the buttons are working and behaving as expected - make sure to change the port being read from if it is not the same as mine. Feel free to exchange the 3D models for other files and adjust the filenames accordingly in the program.
6. Now that the interactive enviornment is setup and working. Use a soldering iron + cables to connect the input devices to M-F cables connected to the ESP32. Make sure not to solder directly to the ESP32 pins.
7. Place the soldered circuit into the 3D printed enclosure once it is finished and screw the enclosure together using long screws that can connect the 2 pieces.
8. Display and have fun!

## How I made it! ⚙️✏️

This section will be divided into multiple unordered parts that all came together in the end:
- Desgining the Circuit
- Designing the Enclosure
- Creating the App 


### Designing the Circuit

<img width="595" alt="Screenshot_2024-10-27_at_3 32 41_PM" src="https://github.com/user-attachments/assets/d636eeee-b60c-4acb-9a39-8d6dc2cba915">

Above is the Fritzing diagram of the circuit used to create my interactive piece. In order to design this, I just added onto the work that we did in class with a potentiometer. To connect everything off the breadboard, I connected female headers to the pins of the joystick and soldering male headers to the pins of the joystick and the button. Then I soldered the male headers on the other side of the cable to the male end of another additional cable which had femlae headers connected to the pins of the ESP32. I did this in order to make sure I was not soldering anything directly to the ESP32. Another thing to note is that I used heat shrink cables to make sure that I was not touching the wiring of the device. 

Heres a video showcasing the completed circuit with all the parts working and some pictures showing some struggles along the way.

![image](https://github.com/user-attachments/assets/adfd45fd-bb8f-4c34-becc-1eedc5be7804)

![image](https://github.com/user-attachments/assets/63189161-b822-4305-9281-c7ca2561d702)

https://github.com/user-attachments/assets/95524574-d8b4-4d58-8bdc-5e6aabddf95a

## Designing the Enclosure!

In order to design the enclosure, I used the website onshape! I knew that I wanted to use screws to connect a top piece to a bottom piece because I figured that would be easy! I also wanted to abstract all the wiring for a user so that they would not need to worry about the implementation of how everything was connected and just have the ESP32's USB-C port available on one end of the enclosure. I had to make the enclosure large to accomodate for the fact that the ESP would also be in it. In order to create the hole sizes, I used size measurements during class to make holes necessary for the input devices. To get the sizes of the holes for the screws, I looked at the size of the screws that were available to me in the makerspace and used that as reference for the sizes of the holes. 

Everything ended up working out mostly perfectly. I think something to note about my enclosure is that there is nothing that supports the input devices, so its pretty easy for them to fall out of place, which is problematic. I would recommend for people following this guide to fix that, and that is something that I would fix in the future for updates to this device. I additionally sanded the bottom and corners so that it was more smooth. I tried to create rounded corners in onshape but the corners were sharper than I expected they were going to be. 

![image](https://github.com/user-attachments/assets/187e86f9-8bb3-4772-9fbc-0c61c453453f)

Just the bottomn:
![image](https://github.com/user-attachments/assets/67617045-8d6d-425e-92ef-f05984d5a2af)

Just the top: 
![image](https://github.com/user-attachments/assets/3f6ff325-8599-4d43-b39b-3a7ade00a150)

Here is a video showcasing the enclosure!

## Creating the App 

Creating the app was definitely the longest part of this process! I knew the idea in my head I wanted to go for so it was pretty easy to get started. First I worked on getting a capybara spinning to start my work. 

In order to create the 3D models I used blender and followed this tutorial by [sneepsnorp3d, my inspiration for the project](https://www.youtube.com/watch?v=sFWlIXKcqXY&t=3s&ab_channel=sneepsnorp3d). I then created an extra outline object and objects that included different hats including a Propellor hat, Halo ring, Croc, and a gas mask. In order to display any 3D model in Processing it is actually quite easy. Processing has a built in .obj file reader where it can display a 3D object with the materials of the object applied to it. Additionally, it can use textures to texture a 3D model. This was awesome, but .obj files have a lack of important features that I wanted to use in order to create an outline for my models and it was critical to me to get a rendered outline to create the vibe I wanted for the project. It ended up taking quite some time to figure out how to get this working. I ended up following a bunch of guides and posts on the processing forum page and stack overflow in order to get everything working how I wanted. I outline the process for creating the outline in my blog update, but essentially, I utilized backface culling and inverted normals with a different texture to accomplish the goal I was trying to display. After that was done I was able to display the following. 

![capyspin](https://github.com/user-attachments/assets/98538975-145c-446e-9e4d-4de30dec2986)

After getting the basic capybara spinning working, I started working on setting up new modes so that you could change the background color, the capybaras color, the outline color and the capybaras hat. This was less time consuming, but I was designing code that would be flexible for multiple animals. Because of this, I ended up spending a lot of time working on a file parsing system to open files and read them which I actually didn't end up using in the end since I didn't have enough time to make additional models and hats. I also spent a lot of time designing my own animation system to change the modes which I also wanted to use to change the animals. In the end Processing has so many features that make it really easy and fun to create stuff like this, so it wasn't for naught because I learned so much about processing!

My animation system for swapping modes can be found in the ModeBox class and the parsing and animal generic code was in the Animal Class and the functions above it. Additionallly, most of my preliminary testing was done using user input provided by a keyboard so I have some events that handle user input with a keyboard.

For the modes, I had created some sprites to display in the mode label box but I ended not not using them. Heres what they looked like though!

![image](https://github.com/user-attachments/assets/d65a2e7c-476c-4acc-ab95-caf277d592e9)


In the end this is a video of what interaction with my demo looked like! 

https://github.com/user-attachments/assets/06c4ec06-ecd6-45c6-957b-f92a054a899e





