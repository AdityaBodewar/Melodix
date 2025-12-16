import { createContext, useContext, useState, useRef, useEffect } from "react";

const AudioContext = createContext();

export const AudioProvider = ({ children }) => {
  const audioRef = useRef(new Audio());
  const [song, setSong] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [isFullScreen, setIsFullScreen] = useState(false);

  
  const playSong = (newSong) => {
    if (song?._id !== newSong._id) {
      setSong(newSong);
      audioRef.current.src = newSong.Song;
      audioRef.current.play();
      setIsPlaying(true);
    }
  };

  const togglePlay = () => {
    if (!song) return;
    if (isPlaying) {
      audioRef.current.pause();
    } else {
      audioRef.current.play();
    }
    setIsPlaying(!isPlaying);
  };

  const seek = (value) => {
    audioRef.current.currentTime = value;
  };

  useEffect(() => {
    const audio = audioRef.current;

    const timeUpdate = () => setCurrentTime(audio.currentTime);
    const loaded = () => setDuration(audio.duration);

    audio.addEventListener("timeupdate", timeUpdate);
    audio.addEventListener("loadedmetadata", loaded);

    return () => {
      audio.removeEventListener("timeupdate", timeUpdate);
      audio.removeEventListener("loadedmetadata", loaded);
    };
  }, []);

  return (
    <AudioContext.Provider
  value={{
    song,
    playSong,
    isPlaying,
    togglePlay,
    currentTime,
    duration,
    seek,
    isFullScreen,
    setIsFullScreen
  }}
>
      {children}
    </AudioContext.Provider>
  );
};

export const useAudio = () => useContext(AudioContext);
