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
import { useAudio } from '../ContextProvider/AudioContext';
import MiniPlayer from '../Components/MiniPlayer'

const HomePage = () => {
  const { isFullScreen } = useAudio(); 

  return (
    <>
      <div className="nav w-full fixed top-0 left-0 z-50  ">
        <NavBar />
      </div>

      <div className="container flex flex-col mt-13 lg:mt-20 md:flex-row lg:flex-row ">

        <div className="head w-full lg:w-30  rounded-2xl lg:h-[calc(100vh-95px)]">
          <div className=" h-full lg:w-35 overflow-x-auto lg:overflow-y-auto lg:overflow-x-hidden">
            <CreatePlaylist />
          </div>
        </div>

        <div className=" rounded-2xl w-full lg:w-[1190px] mb-15">
          <div className="overflow-x-auto w-full ">
            <GetAllMusic />
          </div>

          <div className="overflow-x-auto w-full  ">
            <GetAllArtist />
          </div>
        </div>

        <div className="footer  rounded-2xl  mb-15">
          <NowPlayingDetails />
        </div>

      </div>

      {isFullScreen && <FullScreenPlayer />}

      <div className="fixed bottom-0 left-0 w-full z-40 ">
        <MiniPlayer />
      </div>
    </>
  );
};

export default HomePage;
