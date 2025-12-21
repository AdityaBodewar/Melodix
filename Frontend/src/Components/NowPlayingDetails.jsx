import { useAudio } from "../ContextProvider/AudioContext";
import img from "../assets/music_default_logo.jpeg"

const NowPlayingDetails = () => {
  const { song, isPlaying, currentTime, duration } = useAudio();

  if (!song) {
    return (
      <div className="bg-base-200 w-80 rounded-xl p-5 flex-col h-full  items-center shadow-md hidden lg:block ml-9">

     
      <img
        src={img} />

    
      <div className="flex-1">
        <h3 className="font-semibold text-4xl">No song is currently playing </h3>
       

       
      </div>
    </div>
    );
  }

  const formatTime = (t) => {
    const m = Math.floor(t / 60);
    const s = Math.floor(t % 60).toString().padStart(2, "0");
    return `${m}:${s}`;
  };

  const progress =
    duration > 0 ? Math.floor((currentTime / duration) * 100) : 0;

  return (
    <div className=" w-80 rounded-xl p-5 flex-col h-full  items-center shadow-md lg:block hidden">

     
      <img
        src={song.Image}
        alt={song.Title}
        className="w-full h-70 rounded-lg object-cover "
      />

     
      <div className="flex-1">
        <h3 className="font-semibold text-4xl">{song.Title}</h3>
        <p className="text-2xl text-gray-500 mt-5">{song.Singer}</p>

        
      </div>
    </div>
  );
};

export default NowPlayingDetails;
