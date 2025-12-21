import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

const AddSongOnPlaylistPage = () => {
  const { playlistId } = useParams();
  const navigate = useNavigate();

  const [songs, setSongs] = useState([]);
  const [search, setSearch] = useState("");
  const [filteredSongs, setFilteredSongs] = useState([]);
  const [message, setMessage] = useState("");
  const [loadingSongId, setLoadingSongId] = useState(null);

  useEffect(() => {
    const fetchSongs = async () => {
      try {
        const res = await axios.get(
          "https://melodix-1.onrender.com/getallmusic"
        );
        setSongs(res.data.data);
        setFilteredSongs(res.data.data);
      } catch (err) {
        console.error(err);
      }
    };
    fetchSongs();
  }, []);

  useEffect(() => {
    const filtered = songs.filter((song) =>
      song.Title.toLowerCase().includes(search.toLowerCase())
    );
    setFilteredSongs(filtered);
  }, [search, songs]);

  const handleAddSong = async (songId) => {
    setLoadingSongId(songId);
    try {
      const token = localStorage.getItem("Token");
      await axios.post(
        "https://melodix-1.onrender.com/addSongToPlaylist",
        { playlist_id: playlistId, song_id: songId },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      navigate(`/playlist/${playlistId}`);
    } catch (err) {
      setMessage(err.response?.data?.error || "Error adding song");
    } finally {
      setLoadingSongId(null);
    }
  };

  return (
    <div className="px-3 sm:px-6 py-4 max-w-7xl mx-auto">
      <h2 className="text-lg sm:text-2xl font-bold mb-4">
        Add Songs to Playlist
      </h2>

      <input
        type="text"
        placeholder="Search songs..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="border px-3 py-2 w-full mb-4 rounded-full text-sm sm:text-base pl-4 "
      />

      <div className="space-y-2">
        {filteredSongs.length > 0 ? (
          filteredSongs.map((song) => (
            <div
              key={song._id}
              className="flex items-center gap-3 sm:gap-5 px-3 py-2 border rounded-lg hover:bg-gray-100 transition"
            >
              <img
                src={song.Image || "https://via.placeholder.com/80"}
                alt={song.Title}
                className="w-12 h-12 sm:w-14 sm:h-14 object-cover rounded-md"
              />

              <div className="flex-1 min-w-0">
                <h3 className="font-medium text-sm sm:text-lg truncate">
                  {song.Title}
                </h3>
                <p className="text-gray-500 text-xs sm:text-sm truncate">
                  {song.Singer}
                </p>
              </div>

              <div className="hidden sm:block text-gray-400 italic text-sm w-32">
                {song.Type}
              </div>

              <button
                onClick={() => handleAddSong(song._id)}
                disabled={loadingSongId === song._id}
                className={`px-4 py-1.5 text-xs sm:text-sm rounded-md text-white
                  bg-green-500 hover:bg-green-600 transition
                  ${
                    loadingSongId === song._id
                      ? "opacity-60 cursor-not-allowed"
                      : ""
                  }
                `}
              >
                Add
              </button>
            </div>
          ))
        ) : (
          <p className="text-center text-gray-500 text-sm">
            No songs found
          </p>
        )}
      </div>

      {message && (
        <p className="mt-4 text-center text-red-500 text-sm">
          {message}
        </p>
      )}
    </div>
  );
};

export default AddSongOnPlaylistPage;
