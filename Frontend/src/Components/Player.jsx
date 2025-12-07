import React, { useEffect, useRef, useState } from "react";

const Player = ({ songurl }) => {
  const audioRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const isSeekingRef = useRef(false);

  // Play the song when songurl changes
  useEffect(() => {
    if (audioRef.current && songurl) {
      audioRef.current.pause();
      audioRef.current.load();
      audioRef.current.play().catch(err => {
        console.error("Playback error:", err);
        setIsPlaying(false);
      });
      setIsPlaying(true);
    }
  }, [songurl]);

  // Setup event listeners (only once)
  useEffect(() => {
    const audio = audioRef.current;
    if (!audio) return;

    const updateTime = () => {
      if (!isSeekingRef.current) {
        setCurrentTime(audio.currentTime);
      }
    };

    const updateDuration = () => {
      setDuration(audio.duration || 0);
    };

    const handleEnded = () => {
      setIsPlaying(false);
      setCurrentTime(0);
    };

    const handlePlay = () => {
      setIsPlaying(true);
    };

    const handlePause = () => {
      setIsPlaying(false);
    };

    audio.addEventListener('timeupdate', updateTime);
    audio.addEventListener('loadedmetadata', updateDuration);
    audio.addEventListener('durationchange', updateDuration);
    audio.addEventListener('ended', handleEnded);
    audio.addEventListener('play', handlePlay);
    audio.addEventListener('pause', handlePause);

    return () => {
      audio.removeEventListener('timeupdate', updateTime);
      audio.removeEventListener('loadedmetadata', updateDuration);
      audio.removeEventListener('durationchange', updateDuration);
      audio.removeEventListener('ended', handleEnded);
      audio.removeEventListener('play', handlePlay);
      audio.removeEventListener('pause', handlePause);
    };
  }, []); // Empty dependency array - only runs once

  // Play / Pause toggle
  const togglePlay = () => {
    if (audioRef.current) {
      if (!isPlaying) {
        audioRef.current.play().catch(err => {
          console.error("Playback error:", err);
        });
      } else {
        audioRef.current.pause();
      }
    }
  };

  // When user starts dragging the seek bar
  const handleSeekStart = (e) => {
    isSeekingRef.current = true;
    if (audioRef.current && isPlaying) {
      audioRef.current.pause();
    }
  };

  // While dragging
  const handleSeekChange = (e) => {
    const time = parseFloat(e.target.value);
    setCurrentTime(time);
    if (audioRef.current) {
      audioRef.current.currentTime = time;
    }
  };

  // When user releases the seek bar
  const handleSeekEnd = (e) => {
    isSeekingRef.current = false;
    if (audioRef.current && isPlaying) {
      audioRef.current.play().catch(err => {
        console.error("Playback error:", err);
      });
    }
  };

  // Format time mm:ss
  const formatTime = (time) => {
    if (!time || isNaN(time)) return "0:00";
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60)
      .toString()
      .padStart(2, "0");
    return `${minutes}:${seconds}`;
  };

  const progress = duration > 0 ? (currentTime / duration) * 100 : 0;

  return (
    <div style={{
      position: "fixed",
      bottom: 0,
      left: 0,
      right: 0,
      backgroundColor: "#1a1a1a",
      color: "#fff",
      padding: "15px 20px",
      boxShadow: "0 -2px 10px rgba(0,0,0,0.3)",
      zIndex: 1000
    }}>
      <audio ref={audioRef}>
        <source src={songurl} type="audio/mpeg" />
      </audio>

      <div style={{
        display: "flex",
        alignItems: "center",
        gap: "15px",
        maxWidth: "1200px",
        margin: "0 auto"
      }}>
        {/* Play / Pause button */}
        <button 
          onClick={togglePlay}
          style={{
            backgroundColor: "#1db954",
            color: "#fff",
            border: "none",
            borderRadius: "50%",
            width: "40px",
            height: "40px",
            fontSize: "16px",
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            flexShrink: 0,
            transition: "transform 0.1s"
          }}
          onMouseDown={(e) => e.currentTarget.style.transform = "scale(0.95)"}
          onMouseUp={(e) => e.currentTarget.style.transform = "scale(1)"}
        >
          {isPlaying ? "⏸" : "▶"}
        </button>

        {/* Time - Current */}
        <span style={{
          fontSize: "12px",
          minWidth: "40px",
          flexShrink: 0
        }}>
          {formatTime(currentTime)}
        </span>

        {/* Seek Bar */}
        <input
          type="range"
          min="0"
          max={duration || 0}
          value={currentTime}
          onChange={handleSeekChange}
          onMouseDown={handleSeekStart}
          onMouseUp={handleSeekEnd}
          onTouchStart={handleSeekStart}
          onTouchEnd={handleSeekEnd}
          step="0.1"
          style={{
            flex: 1,
            height: "5px",
            cursor: "pointer",
            accentColor: "#1db954",
            background: `linear-gradient(to right, #1db954 0%, #1db954 ${progress}%, #4d4d4d ${progress}%, #4d4d4d 100%)`,
            borderRadius: "5px"
          }}
        />

        {/* Time - Duration */}
        <span style={{
          fontSize: "12px",
          minWidth: "40px",
          flexShrink: 0
        }}>
          {formatTime(duration)}
        </span>
      </div>
    </div>
  );
};

export default Player;