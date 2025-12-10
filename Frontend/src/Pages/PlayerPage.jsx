import React, { useRef, useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";

const PlayerPage = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const song = location.state?.song;
  const autoplay = location.state?.autoplay || false;

  const audioRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const isSeekingRef = useRef(false);

  // Redirect if no song
  useEffect(() => {
    if (!song) navigate("/");
  }, [song, navigate]);

  // Play if user clicked a song (autoplay flag)
  useEffect(() => {
    if (autoplay && audioRef.current) {
      audioRef.current.play()
        .then(() => setIsPlaying(true))
        .catch(() => setIsPlaying(false)); // autoplay blocked
    }
  }, [autoplay]);

  const togglePlay = () => {
    if (!audioRef.current) return;
    if (isPlaying) {
      audioRef.current.pause();
    } else {
      audioRef.current.play().catch(() => {});
    }
    setIsPlaying(!isPlaying);
  };

  const handleTimeUpdate = () => {
    if (!isSeekingRef.current) setCurrentTime(audioRef.current.currentTime);
  };

  const handleLoadedMetadata = () => setDuration(audioRef.current.duration);

  const handleSeekStart = () => {
    isSeekingRef.current = true;
    if (audioRef.current && isPlaying) audioRef.current.pause();
  };
  const handleSeekChange = (e) => {
    const value = parseFloat(e.target.value);
    setCurrentTime(value);
    if (audioRef.current) audioRef.current.currentTime = value;
  };
  const handleSeekEnd = () => {
    isSeekingRef.current = false;
    if (audioRef.current && isPlaying) audioRef.current.play().catch(() => {});
  };

  const formatTime = (time) => {
    if (!time) return "0:00";
    const min = Math.floor(time / 60);
    const sec = Math.floor(time % 60).toString().padStart(2, "0");
    return `${min}:${sec}`;
  };

  if (!song) return null;

  return (
    <div className="min-h-screen bg-gray-900 text-white flex flex-col items-center justify-center p-4">
      <img
        src={song.Image || "https://via.placeholder.com/300"}
        alt={song.Title}
        className="w-72 h-72 md:w-96 md:h-96 rounded-xl object-cover mb-6 shadow-lg"
      />
      <h1 className="text-2xl font-bold">{song.Title}</h1>
      {song.Artist && <p className="text-gray-400">{song.Artist}</p>}

      <div className="flex flex-col items-center gap-4 mt-4 w-full max-w-lg">
        <button
          onClick={togglePlay}
          className="bg-blue-600 hover:bg-blue-700 px-6 py-3 rounded-full text-white font-semibold"
        >
          {isPlaying ? "Pause ❚❚" : "Play ▶"}
        </button>

        <div className="flex items-center gap-2 w-full">
          <span>{formatTime(currentTime)}</span>
          <input
            type="range"
            min="0"
            max={duration || 0}
            value={currentTime}
            onChange={handleSeekChange}
            onMouseDown={handleSeekStart}
            onMouseUp={handleSeekEnd}
            step="0.1"
            className="flex-1 h-2 rounded-lg accent-green-500"
          />
          <span>{formatTime(duration)}</span>
        </div>
      </div>

      <audio
        ref={audioRef}
        src={song.Song} // must be a valid URL
        onTimeUpdate={handleTimeUpdate}
        onLoadedMetadata={handleLoadedMetadata}
      />
    </div>
  );
};

export default PlayerPage;
