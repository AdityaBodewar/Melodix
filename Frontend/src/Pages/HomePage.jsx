import React from 'react'
import GetAllMusic from '../Components/GetAllMusic'
import NavBar from '../Components/NavBar'
import Login from '../Components/Login'
import AddSongOnPlaylist from '../Components/AddSongOnPlaylist'
import CreatePlaylist from '../Components/CreatePlaylist'
import GetAllArtist from '../Components/GetAllArtist'
import AddMusic from '../Components/AddMusic'
import FullScreenPlayer from '../Components/FullScreenPlayer'
import NowPlayingDetails from '../Components/NowPlayingDetails'

const HomePage = () => {
  return (
    <>
    <div className="nav mb-5 h-full">
      <NavBar/>
    </div>
    <div className="container flex ">

       <div className="head  w-30 border-2 border-black ml-5 rounded-2xl">
        <div className='overflow-x-auto h-full'>
         <CreatePlaylist/>
        
        </div>



    </div>
    <div className="ml-5 w-300 h-150 border-black border-2 rounded-2xl ">
      <div className="overflow-x-auto w-full "  >
      <GetAllMusic/>
      
      </div>
      <div className="overflow-x-auto w-full "  >
      
       <GetAllArtist/>
      </div>
    </div>



    <div className="footer ml-5   border-black border-2 rounded-2xl ">

     <NowPlayingDetails/>
 
      </div> 
    </div>
      
    
    
    </>
  )
}

export default HomePage