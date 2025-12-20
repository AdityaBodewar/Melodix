import { useAudio } from "../ContextProvider/AudioContext";
import {
  FaBackward,
  FaForward,
  FaPlay,
  FaPause,
  FaExpand,
} from "react-icons/fa";

const MiniPlayer = () => {
  const {
    song,
    isPlaying,
    togglePlay,
    currentTime,
    duration,
    seek,
    setIsFullScreen,
  } = useAudio();

  if (!song) return null;

  const formatTime = (t) => {
    if (!t) return "0:00";
    const m = Math.floor(t / 60);
    const s = Math.floor(t % 60).toString().padStart(2, "0");
    return `${m}:${s}`;
  };

  return (
    <div className="fixed bottom-0 left-0 w-full bg-base-100 px-3 py-2 shadow-lg z-50 overflow-x-hidden">

      {/* MAIN CONTAINER — Always row, wrap on small screens */}
      <div className="flex flex-row flex-wrap items-center justify-between gap-3 w-full">

        {/* LEFT — Song Info */}
        <div className="flex flex-col sm:flex-row sm:items-center items-center gap-1 w-auto min-w-0 flex-shrink-0 text-center sm:text-left">
          <img
            src={song.Image}
            className="w-12 h-12 md:w-12 md:h-12 rounded-lg object-cover flex-shrink-0"
          />
          <div className="truncate min-w-0">
            <h3 className="font-semibold text-sm truncate">{song.Title}</h3>
            <p className="text-gray-400 text-xs truncate">{song.Singer}</p>
          </div>
        </div>

        {/* CENTER — Controls + Seekbar */}
        <div className="flex flex-col items-center flex-1 min-w-0">
          {/* Controls */}
          <div className="flex items-center gap-3 mb-1">
            <FaBackward className="cursor-pointer" size={16} />

            <button
              onClick={togglePlay}
              className="bg-white text-black w-9 h-9 md:w-10 md:h-10 flex items-center justify-center rounded-full flex-shrink-0"
            >
              {isPlaying ? <FaPause size={16} /> : <FaPlay size={16} />}
            </button>

            <FaForward className="cursor-pointer" size={16} />
          </div>

          {/* Seekbar */}
          <div className="flex items-center gap-2 w-full min-w-0">
            <span className="text-xs hidden sm:block flex-shrink-0">
              {formatTime(currentTime)}
            </span>

            <input
              type="range"
              min={0}
              max={duration || 0}
              value={currentTime}
              onChange={(e) => seek(Number(e.target.value))}
              className="flex-1 w-full accent-white min-w-0"
            />

            <span className="text-xs hidden sm:block flex-shrink-0">
              {formatTime(duration)}
            </span>
          </div>
        </div>

        {/* RIGHT — Fullscreen */}
        <div className="flex items-center justify-end w-auto flex-shrink-0">
          <FaExpand
            size={20}
            className="cursor-pointer"
            onClick={() => setIsFullScreen(true)}
          />
        </div>

      </div>
    </div>
  );
};

export default MiniPlayer;
