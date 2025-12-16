import { useAudio } from "../ContextProvider/AudioContext";
import { useNavigate } from "react-router-dom";
import { FaBackward, FaForward, FaPlay, FaPause, FaRandom, FaListUl, FaHeadphones, FaVolumeUp, FaExpand } from "react-icons/fa";

const MiniPlayer = () => {
  const navigate = useNavigate();
  const { song, isPlaying, togglePlay, currentTime, duration, seek, setIsFullScreen } = useAudio();

  if (!song) return null;

  const formatTime = (t) => {
    if (!t) return "0:00";
    const m = Math.floor(t / 60);
    const s = Math.floor(t % 60).toString().padStart(2, "0");
    return `${m}:${s}`;
  };

  return (
    <div className="fixed bottom-0 left-0 w-full bg-black text-white px-5 py-3 flex items-center justify-between shadow-lg z-50">

    
      <div className="flex items-center gap-3 w-1/4">
        <img src={song.Image} className="w-12 h-12 rounded-lg object-cover" />
        <div className="leading-tight">
          <h3 className="font-semibold text-sm">{song.Title}</h3>
          <p className="text-gray-300 text-xs">{song.Singer}</p>
        </div>
        
      </div>

      {/* CENTER — Controls + Seekbar */}
      <div className="flex flex-col items-center w-2/4">
        
        {/* Main Controls Row */}
        <div className="flex items-center gap-6 mb-1">
          {/* <FaRandom className="text-green-500 cursor-pointer" size={18} />*/}
          <FaBackward className="cursor-pointer" size={18} /> 

          <button
            onClick={togglePlay}
            className="bg-white text-black w-10 h-10 flex items-center justify-center rounded-full"
          >
            {isPlaying ? <FaPause size={18} /> : <FaPlay size={18} />}
          </button>

        <FaForward className="cursor-pointer" size={18} />
           {/*  <FaListUl className="cursor-pointer" size={18} /> */}
        </div>

        {/* Seekbar */}
        <div className="flex items-center gap-3 w-full">
          <span className="text-xs">{formatTime(currentTime)}</span>

          <input
            type="range"
            min={0}
            max={duration || 0}
            value={currentTime}
            onChange={(e) => seek(parseFloat(e.target.value))}
            className="w-full accent-white"
          />

          <span className="text-xs">{formatTime(duration)}</span>
        </div>

      </div>

      {/* RIGHT — Tools */}
      <div className="flex items-center gap-4 w-1/4 justify-end">
        

      <FaExpand
  size={20}
  className="cursor-pointer"
  onClick={() => setIsFullScreen(true)}
/>
      </div>
    </div>
  );
};

export default MiniPlayer;
