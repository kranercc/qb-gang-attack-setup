### **SETUP QB-PHONE**
1. config.lua
    * Look for `Config.PhoneApplications = {` and add 

```lua
["Gang-Attack"] = {
        app = "Gang-Attack",
        color = "#004682",
        icon = "fas fa-ad",
        tooltipText = "Call a gang attack on your enemy",
        job = false,
        blockedjobs = {},
        slot = 17,
        Alerts = 0,
},
```

2. index.html
    * Press `ctrl+f` and look for `<div class="whatsapp-app">`
    * You should see something like this: 
    * ![](https://i.imgur.com/DApasQQ.png)
    * At the last `</div>` (the one i also put an arrow to), press `ENTER`, and after that `</div>` put the following
  
```html
   <div class="Gang-Attack-app">
        <div class="Gang-Attack-app-header">
            Gang Attack
        </div>
        <p style="color:white; margin-left: 5%; margin-right: 5%; margin-top: 20%; text-align: center;">Press the <span style="color:#e67e22">Call Attack</span> button to call a gang attack one the closest person next to you</p>
        <p style="color:white; margin-left: 5%; margin-right: 5%; margin-top: 5%; text-align: center;">Price for attack <span style="color:#e67e22"> $20.000</span>.</p>
        
        <button id="krane-call-attack">Call attack</button>
    </div> 
```
If you've done it properly, then you should have something like this:
![](https://i.imgur.com/vnZ6Ku6.png)

3. Javascript 
   * [qb] -> qb-phone -> html -> js
   * Create file called: Gang-Attack.js
   * Add this: 
```js
$('#krane-call-attack').click(function(){
    $.post('https://qb-phone/HireHitman', JSON.stringify({}), function(data){});
    QB.Phone.Functions.Close();
});  
```

4. CSS
    * [qb] -> qb-phone -> html -> css
    * Create file called: Gang-Attack.css
```css
.Gang-Attack-app {
    display: none;
    height: 100%;
    width: 100%;
    background: rgb(36, 36, 36);
    overflow: hidden;
}

.Gang-Attack-app-header {
    height: 9vh;
    width: 100%;
    text-align: center;
    line-height: 13.5vh;
    color: white;
    font-family: 'Poppins', sans-serif;
    font-size: 1.5vh;
    border-bottom: 1px solid black;
    background: rgb(24, 24, 24);

}


.Gang-Attack-app > button {
    position: absolute;
    bottom: 10%;
    left: 50%;
    width: 80%;
    transform: translateX(-50%);
    justify-content: center;
    background-color: rgb(25, 39, 63);
    border: 1px solid rgb(0, 0, 0);

    color: white;
    font-family: 'Poppins', sans-serif;
    box-shadow: 1px 1px 1px 1px rgba(0, 0, 0, 0.5);
}

```


### **You finished setting up the QB-PHONE**

Now, all that is left is for you to put the resource you got from my website into your resources folder and start it
    
Edit your server.cfg to add 
```lua
start GangAttack
```

or if you want to put it inside your [qb] folder, then you don't need to do anything else.

Here is a preview for the system: [link will come after the video is public]
