import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { useAudio } from "../ContextProvider/AudioContext";

const AboutArtist = () => {
  const location = useLocation();
  const artist = location.state;
  const [songs, setSongs] = useState([]);
  const [loading, setLoading] = useState(true);
  const { playSong } = useAudio(); 
  useEffect(() => {
    if (!artist || !artist._id) {
      console.error("No artist data found");
      setLoading(false);
      return;
    }

    const artistId = String(artist._id);
    console.log("Fetching songs for artist ID:", artistId);

    fetch(`http://localhost:5000/getsongofartist/${artistId}`)
      .then((res) => {
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res.json();
      })
      .then((data) => {
        setSongs(data.song || data.data || []);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error fetching songs:", err);
        setLoading(false);
      });
  }, [artist]);

  if (!artist) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen">
        <p>No artist data available</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-6">
    
      <div className="bg-base-100 p-6 rounded-xl mb-6">
        <div className="flex items-center gap-4">
          <img
            src={artist.Image || "https://via.placeholder.com/150"}
            alt={artist.Fullname}
            className="w-24 h-24 rounded-full object-cover"
          />
          <div>
            <h1 className="text-3xl font-bold">{artist.Fullname}</h1>
            <p className="text-gray-400">@{artist.Username}</p>
            {artist.Type && (
              <span className="inline-block mt-2 px-3 py-1 bg-blue-600 rounded-full text-sm">
                {artist.Type}
              </span>
            )}
          </div>
        </div>
      </div>

     
      <div className="bg-base-100 p-6 rounded-xl">
        <h2 className="text-2xl font-bold mb-4">Songs</h2>

        {loading ? (
          <p className="text-gray-400">Loading songs...</p>
        ) : songs.length > 0 ? (
          <div className="space-y-3">
            {songs.map((song, index) => (
              <div
                key={song._id || index}
                onClick={() => playSong(song)} 
                className="bg-base-200 p-4 rounded-lg hover:bg-base-300 transition cursor-pointer flex items-center gap-4"
              >
                <img
                  className="w-16 h-16 object-cover rounded-lg"
                  src={song.Image || "https://via.placeholder.com/80"}
                  alt={song.Title}
                />
                <div className="flex-1">
                  <h3 className="text-lg font-semibold">{song.Title}</h3>
                  <p className="text-gray-400">{song.Singer}</p>
                  {song.Type && (
                    <span className="inline-block mt-1 px-2 py-1 bg-gray-600 rounded text-xs">
                      {song.Type}
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-gray-400">No songs found for this artist</p>
        )}
      </div>
    </div>
  );
};

export default AboutArtist;
