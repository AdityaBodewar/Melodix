import React from 'react'
import GetAllMusic from '../Components/GetAllMusic'
import NavBar from '../Components/NavBar'
import Login from '../Components/Login'
import AddSongOnPlaylist from '../Components/AddSongOnPlaylist'
import CreatePlaylist from '../Components/CreatePlaylist'
import GetAllArtist from '../Components/GetAllArtist'
import AddMusic from '../Components/AddMusic'

const HomePage = () => {
  return (
    <>
    <div className="nav mb-5">
      <NavBar/>
    </div>
    <div className="container flex ">

       <div className="head h-150 w-30 border-2 border-blue-100 ">
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



    <div className="footer">
  
  <AddMusic/>
      </div> 
    </div>
      
    
    
    </>
  )
}

export default HomePage