import React, { useEffect, useRef, useState } from "react";

const Player = ({ song }) => {
  const audioRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const isSeekingRef = useRef(false);

  // Play the song when song changes
  useEffect(() => {
    if (audioRef.current && song?.Song) {
      audioRef.current.pause();
      audioRef.current.src = song.Song;
      audioRef.current.load();
      audioRef.current
        .play()
        .then(() => setIsPlaying(true))
        .catch(() => setIsPlaying(false));
    }
  }, [song]);

  // Audio event listeners
  useEffect(() => {
    const audio = audioRef.current;
    if (!audio) return;

    const handleTimeUpdate = () => {
      if (!isSeekingRef.current) setCurrentTime(audio.currentTime);
    };

    const handleLoadedMetadata = () => setDuration(audio.duration || 0);

    const handleEnded = () => {
      setIsPlaying(false);
      setCurrentTime(0);
    };

    audio.addEventListener("timeupdate", handleTimeUpdate);
    audio.addEventListener("loadedmetadata", handleLoadedMetadata);
    audio.addEventListener("ended", handleEnded);

    return () => {
      audio.removeEventListener("timeupdate", handleTimeUpdate);
      audio.removeEventListener("loadedmetadata", handleLoadedMetadata);
      audio.removeEventListener("ended", handleEnded);
    };
  }, []);

  // Play/pause toggle
  const togglePlay = () => {
    if (!audioRef.current) return;
    if (isPlaying) audioRef.current.pause();
    else audioRef.current.play().catch(() => {});
    setIsPlaying(!isPlaying);
  };

  // Seek bar handlers
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

  // Format mm:ss
  const formatTime = (time) => {
    if (!time || isNaN(time)) return "0:00";
    const min = Math.floor(time / 60);
    const sec = Math.floor(time % 60).toString().padStart(2, "0");
    return `${min}:${sec}`;
  };

  const progress = duration > 0 ? (currentTime / duration) * 100 : 0;

  if (!song?.Song) return null;

  return (
    <div
      style={{
        position: "fixed",
        bottom: 0,
        left: 0,
        right: 0,
        backgroundColor: "#1a1a1a",
        color: "#fff",
        padding: "10px 15px",
        display: "flex",
        alignItems: "center",
        gap: "10px",
        boxShadow: "0 -2px 10px rgba(0,0,0,0.3)",
        zIndex: 1000,
      }}
    >
      {/* Song Image */}
      <img
        src={song.Image || "https://via.placeholder.com/50"}
        alt={song.Title}
        style={{
          width: 50,
          height: 50,
          objectFit: "cover",
          borderRadius: "5px",
          flexShrink: 0,
        }}
      />

      {/* Song info + seek bar */}
      <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: "5px" }}>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <div>
            <span style={{ fontSize: 14, fontWeight: 600 }}>{song.Title}</span>
            {song.Artist && (
              <span style={{ fontSize: 12, color: "#aaa", marginLeft: 5 }}>
                {song.Artist}
              </span>
            )}
          </div>
          <span style={{ fontSize: 12 }}>
            {formatTime(currentTime)} / {formatTime(duration)}
          </span>
        </div>

        {/* Seek bar */}
        <input
          type="range"
          min={0}
          max={duration || 0}
          value={currentTime}
          onChange={handleSeekChange}
          onMouseDown={handleSeekStart}
          onMouseUp={handleSeekEnd}
          onTouchStart={handleSeekStart}
          onTouchEnd={handleSeekEnd}
          step="0.1"
          style={{
            width: "100%",
            height: "5px",
            cursor: "pointer",
            accentColor: "#1db954",
            background: `linear-gradient(to right, #1db954 0%, #1db954 ${progress}%, #4d4d4d ${progress}%, #4d4d4d 100%)`,
            borderRadius: "5px",
          }}
        />
      </div>

      {/* Play/Pause */}
      <button
        onClick={togglePlay}
        style={{
          backgroundColor: "#1db954",
          color: "#fff",
          border: "none",
          borderRadius: "50%",
          width: 40,
          height: 40,
          fontSize: 16,
          cursor: "pointer",
          flexShrink: 0,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        {isPlaying ? "⏸" : "▶"}
      </button>

      <audio ref={audioRef}>
        <source src={song.Song} type="audio/mpeg" />
      </audio>
    </div>
  );
};

export default Player;
