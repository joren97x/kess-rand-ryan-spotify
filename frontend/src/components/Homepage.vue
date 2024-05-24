<script setup>

import axios from 'axios'
import { ref, onMounted, watch } from 'vue'
import { useAuthStore } from '@/stores/auth-store'
import { useRouter } from 'vue-router'
import { io } from "socket.io-client"
import { formatDistance } from 'date-fns'

const router = useRouter()
const authStore = useAuthStore()
const messages = ref([])
const message = ref('')
const activeUsers = ref(0)
const tracks = ref([])
const q = ref('illit')
const currentSong = ref('3A2yGHWIzmGEIolwonU69h')
const play = ref(false)
const chosenMessage = ref(null)
const artists = ref([])


const socket = io("http://localhost:3001");

socket.on("active users", (users) => {
	activeUsers.value = users
});

socket.on('chat message', () => {
	getAllMessages()
})

socket.on('delete message', () => {
	getAllMessages()
})

onMounted(async () => {
	getAllMessages()

	var client_id = '3986226f0e2d41b590779b28ce14a56a';
	var client_secret = '146395d6cb6d4e0093984a67141b5bed'

	axios.post('https://accounts.spotify.com/api/token', 
		`grant_type=client_credentials&client_id=${client_id}&client_secret=${client_secret}&scope=user-top-read`, 
		{
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded'
			}
		}
	)
	.then(response => {
		console.log(response.data)
		authStore.access_token = response.data.access_token
		getTracks()
        getArtists()
	})
	.catch(error => {
		console.log("in here 69")
		console.error(error);
	});

})

function getArtists() {
    axios.get('https://api.spotify.com/v1/artists?ids=2CIMQHirSU0MQqyYHq0eOx%2C57dN52uHvrHOxijzpIgu3E%2C1vCWHaC5f2uS3yhpwWbIA6', {
        headers: {
            Authorization: `Bearer ${authStore.access_token}`
        }
    })
    .then((res) => {
        artists.value = res.data.artists
        console.log(res)
    })
    .catch((err) => {
        console.error(err)
    })
}

const getAllMessages = () => {
	axios.get('http://localhost:3000/', {
		headers: {
			Authorization: `Bearer ${authStore.token}`
		}
	})
	.then((res) => {
        console.log(res)
		messages.value = res.data
		// virtualScoller.value.scrollToIndex(messages.value.length - 1)
	}).catch((err) => {
		console.log("in here 5")
		console.error(err)
	})
}


const logout = () => {
	
	router.push('/login')
	authStore.logout()
}

const sendMessage = () => {
	axios.post('http://localhost:3000/send-message', {
		user_id: authStore.authUser.id,
		type: 0,
		message: message.value
	}, {
		headers: {
			Authorization: `Bearer ${authStore.token}`
		}
	}).then((res) => {
		console.log(res)
		if(res.status == 201) {
			socket.emit('chat message')
			message.value = ''
		}
	}).catch((err) => {
		console.log("in here 4")
		console.error(err)
	})
}

const playSong = (trackId) => {
	currentSong.value = trackId
	play.value = true
}

const shareSong = (trackId) => {
	axios.post('http://localhost:3000/send-message', {
		user_id: authStore.authUser.id,
		type: 1,
		message: trackId
	}, {
		headers: {
			Authorization: `Bearer ${authStore.token}`
		}
	}).then((res) => {
		console.log(res)
		if(res.status == 201) {
			socket.emit('chat message')
			message.value = ''
		}
	}).catch((err) => {
		console.log("in here 3")
		console.error(err)
	})
}

const getTracks = () => {
	axios.get(`https://api.spotify.com/v1/search?q=${q.value}&type=track&limit=5`, {
		headers: {
			Authorization: `Bearer ${authStore.access_token}`
		}
	})
	.then((res) => {
		tracks.value = res.data.tracks.items
		console.log(res)
		// q.value = ''
	})
	.catch((err) => {
		console.log("in here")
		console.log(err)
	})

}

</script>

<template>
    <div class="wrapper">
        <div class="sidebar">
            <h2>Chats</h2>
            <!-- {{ messages }} -->
            <div class="message-page">
                  <div class="message">
                    <div class="messsage-page">
        
                        <template v-for="(message, index) in messages" :key="index">

                            <div class="outgoing-chat" v-if="message.user_id == authStore.authUser?.id">
                                <div class="outgoing-chat-msg">
                                <span class="username2">{{ message.name }}</span>
                                <p>{{ message.message }}</p>
                                <!-- <p>hi po.. Lorem ipsum dolor quod earum eius dolorum incidunt, debitis nulla! Alias.</p> -->
                                </div>
                                <div class="outgoing-chat-img">
                                <img src="img/profile.png" alt="">
                                </div>
                            </div>

                            <div class="received-chat" v-else>
                                <div class="received-chat-img">
                                <img src="img/user1.png" alt="image">
                                </div>
                                <div class="received-msg">
                                <div class="received-msg-inbox">
                                    <span class="username1">{{ message.name }}</span>
                                    <p>{{ message.message }}</p>
                                </div>
                                </div>
                            </div>
                
                            
                        </template>
                     
                    </div>
                  </div>
              </div>
            <div class="textbox">
              <form @submit.prevent="sendMessage">
                <input type="text" v-model="message" class="chat-input" placeholder="Type a message...">
                <button class="send-button" type="submit"><ion-icon name="send-outline"></ion-icon></button>
            </form>
          </div>
        </div>

        <div class="main_content">
            <div class="header">
              <nav class="navbar navbar-expand-lg navbar-light">
                <div class="container-fluid">
                  <a class="navbar-brand" href="#">
                    <img src="img/spo.jpg" alt="Logo" class="d-inline-block align-text-top">
                  </a>
                  <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon text-light"></span>
                  </button>
                  <div class="collapse navbar-collapse" id="navbarNav">
                    <form class="d-flex mx-auto search" @submit.prevent="getTracks">
                      <input class="form-control me-2" v-model="q" type="search" placeholder="Search" aria-label="Search">
                      <button class="btn btn-outline-success" type="submit">Search</button>
                    </form>
                    <ul class="navbar-nav ms-auto">
                      <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-light" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                          <img src="img/profile.png" alt="Profile" class="rounded-circle"> Profile
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                          <!-- <li><a class="dropdown-item" href="#">Logout</a></li> -->
                          <button class="dropdown-item" @click="logout">Logout</button>
                        </ul>
                      </li>
                    </ul>

                  </div>
                </div>
              </nav>
            </div>  

           <div class="music-player mb-5">
            <iframe class="mb-5" style="border-radius:12px" :src="`https://open.spotify.com/embed/track/${currentSong}?utm_source=generator`" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>

              <!-- <div class="music">
               <img src="img/bini.jpg" alt="">
               <h5>
                  In my way <br>
                  <div class="subtitle">Alan Walker</div>
               </h5>
                  <div class="icon">
                    <ion-icon class="bi" name="play-skip-back-outline"></ion-icon>
                    <ion-icon class="bi" name="play-outline"></ion-icon>
                    <ion-icon class="bi" name="play-skip-forward-outline"></ion-icon>
                  </div>
                  <span id="currentStart">0:00</span>
                  <div class="bar">
                    <input type="range" id="seek" min="0" value="0" max="100">
                    <div class="bar2" id="bar2"></div>
                    <div class="dot"></div>
                  </div>
                  <span id="currentEnd">0:00</span>
             
                   <div class="vol">
                    <ion-icon class="bi" name="volume-high-outline"></ion-icon>
                    <input type="range" id="vol" min="0" value="20" max="100">
                    <div class="vol_bar"></div>
                    <div class="dot" id="dot_vol"></div>
                   </div>
              </div> -->
           </div>
            <div class="info">
               <h1 class=" mt-5">Recently Played</h1>
              <div class="card-container">
                  
                <template v-for="(track, index) in tracks" :key="index">
                    <iframe class="" style="border-radius:12px" :src="`https://open.spotify.com/embed/track/${track.id}?utm_source=generator`" width="100%" height="152" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>
                </template>
            </div> 


              <div class="fav-artist">
                <h1>Favorite Artist</h1>
                <div class="artist-content">
                  
                 <div class="artist-body" v-for="(artist, index) in artists" :key="index">
                     <img :src="artist.images[0].url" alt="">
                     <h1>{{artist.name}}</h1>
                      <p>Artist</p>
                 </div>
 
               </div>
              </div>
            
          </div>
        </div>



        
    </div>
</template>

<style scoped>
    @import url('https://fonts.googleapis.com/css?family=Josefin+Sans&display=swap');

    *{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    list-style: none;
    text-decoration: none;
    font-family: 'Josefin Sans', sans-serif;
    }

    body{
    background-color: #f3f5f9;
    }

    /* header side */
    .wrapper .main_content .header{
    padding: 20px;
    height: 90px;
    background: #000000;
    color: #717171;
    border-bottom: 1px solid #e0e4e8;
    }

    .navbar-brand img {
    width: 40px;
    border-radius: 25px;
    }
    .navbar-nav .nav-link:hover {
    color: #007bff;
    }
    .navbar-nav .dropdown-menu {
    min-width: 200px;
    }
    .navbar-nav .nav-link img {
    width: 30px;
    height: 30px;
    margin-right: 8px;
    }

    .wrapper{
    display: flex;
    position: relative;
    }

    .wrapper .sidebar{
    width: 350px;
    height: 100%;
    background: #cecdd4;
    padding: 30px 0px;
    position: fixed;
    }

    .wrapper .sidebar h2{
    color: #000000;
    text-transform: uppercase;
    text-align: center;
    margin-bottom: 30px;
    }


    .wrapper .sidebar .textbox {
    padding: 5px;
    }
    .wrapper .sidebar .textbox .chat-input {
    padding: 2px;
    width: 290px;
    }

    .wrapper .main_content{
    width: 100%;
    height: 100vh;
    margin-left: 350px;
    background: #ffffff;
    }


    .wrapper .main_content .info{
    margin: 20px;
    color: #000000;
    line-height: 25px;
    
    }


    @media (max-height: 500px){
    .social_media{
        display: none !important;
    }
    }



    .message-page {
        background-color: #ffffff;
        height:450px;
        width: 55vh;
        overflow-y: auto;
        margin-top: 10px;
    }
    
    .received-chat{
        margin-top: 10px;
    }
    .received-chat-img {
        display: inline-block;
        width: 10px;
    }
    
    .received-chat-img img {
        width: 30px;
        border-radius: 25px;
        margin-right: 15%;
        float: left;
    
    }
    .received-msg {
        margin-top: 8px;
        display: inline-block;
        padding: 0 0 0 4px;
        vertical-align: top;
        width: 29px;
        margin-left: 20px;
    }
    
    
    
    .received-msg-inbox {
        width: 150px;
    }
    
    .received-msg-inbox p {
        background: #594a4a;
        border-radius: 10px;
        color: #ffffff;
        font-size: 14px;
        margin: 1px;
        padding: 5px 10px 5px 12px;
        width: 100%;
    }
    
    .outgoing-chat {
        overflow: hidden;
        margin: 26px 20px;
        
    }
    
    .outgoing-chat-msg p {
        background: #9c7676;
        border-radius: 10px;
        color: #ffffff;
        font-size: 14px;
        margin-right: 2px;
        /* padding: 5px 10px 5px 12px; */
        width: 100%;
    }
    
    .outgoing-chat-msg {
        float: left;
        width: 175px;
        margin-left: 50px;
    }
    
    .outgoing-chat-img {
        display: inline-block;
        /* width: 5%; */
        margin-top: 15%;
        float: right;
    }
    

    .card-container {
    display: flex;
    justify-content: space-between;
    gap: 1px;
    margin-top: 10px;
    }
    .card {
    width: 180px;
    height: 33vh;
    background-color: rgb(190, 43, 43);
    border-radius: 20px;
    box-shadow: 0px 5px 10px rgb(0, 0, 0, 0.3);
    cursor: pointer;
    }

    .card-content {
    text-align: center;
    padding: 5px;
    line-height: 1.3;

    }

    .card-content h1 {
    font-size: 15px;
    margin-top: 2px;
    margin-bottom: 10px;
    color: rgb(0, 0, 0);
    }
    .card-content p {
    font-size: 13px;
    margin-bottom: 10px;
    color: rgb(0, 0, 0);
    }

    .card-content img {
    width: 150px;
    height: 120px;
    }

    .artist-content {
    display: flex;
    justify-content: space-between;
    gap: 1px;
    margin-top: 10px;
    
    }

    .fav-artist h1 {
    margin-top: 100px;
    color: #000000;
    }

    .artist-content .artist-body {
    width: 180px;
    height: 38vh;
    background-color: #f7f7f7;
    border-radius: 20px;
    box-shadow: 0px 5px 10px rgb(0, 0, 0, 0.3);
    text-align: center;
    padding: 10px;
    cursor: pointer;
    }

    .artist-body img {
    width: 150px;
    height: 150px;
    border-radius: 125px;
    margin-top: 5px;
    
    }

    .artist-body h1{
    font-size: 20px;
    margin-top: 2px;
    }

    .artist-body p {
    font-size: 20px;
    }

    .music-player {
    padding: 10px;
    background-color: #c3ccc4;
    height: 100px;
    width: 96%; 
    margin-top: 20px;
    margin-left: 20px;
    }

    .music-player .music {
    display: flex;
    justify-items: stretch;
    margin-top: 20px;
    }
    .music-player .music img{
        width: 49px;
        height: 49px;
        margin-left: 20px;
    }

    .music-player .music h5{
    width: 130px;
    font-size: 20px;
    margin-left: 15px;
    font-weight: 500;
    }

    .music-player .music h5 .subtitle{
    font-size: 11px;
    color: wheat;
    }

    .music-player .music .icon {
    font-size: 20px;
    color: rgb(0, 0, 0);
    margin: 10px 20px 0px 40px;
    }
    
    .music-player .music .icon .bi {
    cursor: pointer;
    outline: none;
    }

    .music-player .music .icon .bi:nth-child(2) {
    border: 1px solid rgb(105, 105, 107,.1);
    border-radius: 50%;
    padding: 1px 3px 0px 6px;
    margin: 0px 5px;
    transition: .3s linear;
    }

    .music-player .music span {
    color: white;
    width: 40px;
    font-size: 20px;
    font-weight: 400;
    margin-top: 10px;
    }



    .music-player .bar {
    position: relative;
    width: 30%;
    height: 2px;
    background: rgba(0, 0, 0, 0.1);
    margin: 23px 15px 0px 10px;
    }

    .music-player .bar .bar2 {
    position: absolute;
    background: #007bff;
    width: 0%;
    height: 100%;
    top: 0;
    }

    .music-player .bar .dot {
    position: absolute;
    width: 5px;
    height: 5px;
    background: skyblue;
    border-radius: 50%;
    left: 0%;
    top: -1px;
    transition: 1s linear;
    }

    .music-player .bar .dot:before {
    content: '';
    position: absolute;
    width: 15px;
    height: 15px;
    border: 1px solid skyblue;
    border-radius: 50%;
    left: -6px;
    top: -6px;
    box-shadow: inset 0px 0px 3px skyblue;
    }

    .music-player .bar input {
    position: absolute;
    width: 100%;
    top: -6px;
    left: 0;
    cursor: pointer;
    z-index: 99999999;
    transition: 3s linear;
    opacity: 0;
    }

    .music-player .vol {
    position: relative;
    width: 100px;
    height: 2px;
    margin-left: 50px;
    margin-top: 25px;
    background: black;
    }

    .music-player .vol .bi {
    position: absolute;
    color: white;
    font-size: 25px;
    margin-top: 5px;
    top: -17px;
    left: -30px;
    }
    .music-player .vol input {
    position: absolute;
    width: 100%;
    top: -10px;
    left: 0;
    cursor: pointer;
    z-index: 99999999;
    transition: 3s linear;
    opacity: 0;
    }


    .music-player .vol .vol_bar {
    position: absolute;
    background: #007bff;
    width: 0%;
    height: 100%;
    top: 0;
    }

    .music-player .vol .dot {
    position: absolute;
    width: 5px;
    height: 5px;
    background: skyblue;
    border-radius: 50%;
    left: 0%;
    top: -1px;
    transition: 1s linear;
    }

    .music-player .vol .dot:before {
    content: '';
    position: absolute;
    width: 15px;
    height: 15px;
    border: 1px solid skyblue;
    border-radius: 50%;
    left: -6px;
    top: -6px;
    box-shadow: inset 0px 0px 3px skyblue;
    }
</style>