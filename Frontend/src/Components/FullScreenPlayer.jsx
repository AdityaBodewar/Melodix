import { useAudio } from "../ContextProvider/AudioContext";
import {
  FaChevronDown,
  FaPlay,
  FaPause,
  FaBackward,
  FaForward
} from "react-icons/fa";

const FullScreenPlayer = () => {
  const {
    song,
    isPlaying,
    togglePlay,
    currentTime,
    duration,
    seek,
    setIsFullScreen
  } = useAudio();

  if (!song) return null;

  const formatTime = (t) => {
    const m = Math.floor(t / 60);
    const s = Math.floor(t % 60).toString().padStart(2, "0");
    return `${m}:${s}`;
  };

  return (
    <div className="fixed inset-0 bg-gradient-to-b from-black to-gray-900 text-white z-[100]">

      {/* HEADER */}
      <div className="flex items-center justify-between p-5">
        <FaChevronDown
          size={22}
          className="cursor-pointer"
          onClick={() => setIsFullScreen(false)}
        />
        <p className="text-sm">Now Playing</p>
        <div />
      </div>

      {/* CONTENT */}
      <div className="flex flex-col items-center justify-center h-[75%]">
        <img
          src={song.Image}
          className="w-72 h-72 rounded-xl shadow-2xl mb-6"
        />

        <h2 className="text-2xl font-bold">{song.Title}</h2>
        <p className="text-gray-400">{song.Singer}</p>
      </div>

      {/* CONTROLS */}
      <div className="px-10 pb-10">

        <div className="flex items-center gap-3 text-xs mb-2">
          <span>{formatTime(currentTime)}</span>
          <input
            type="range"
            min={0}
            max={duration || 0}
            value={currentTime}
            onChange={(e) => seek(e.target.value)}
            className="w-full accent-white"
          />
          <span>{formatTime(duration)}</span>
        </div>

        <div className="flex justify-center items-center gap-10 mt-4">
          <FaBackward size={26} />
          <button
            onClick={togglePlay}
            className="bg-white text-black w-16 h-16 rounded-full flex items-center justify-center"
          >
            {isPlaying ? <FaPause size={26} /> : <FaPlay size={26} />}
          </button>
          <FaForward size={26} />
        </div>

      </div>
    </div>
  );
};

export default FullScreenPlayer;
