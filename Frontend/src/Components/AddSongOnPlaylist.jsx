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
  const [loading, setLoading] = useState(false);

 
  useEffect(() => {
    const fetchSongs = async () => {
      try {
        const res = await axios.get("http://localhost:5000/getallmusic");
        setSongs(res.data.data);
        setFilteredSongs(res.data.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchSongs();
  }, []);

  // Filter songs based on search
  useEffect(() => {
    const filtered = songs.filter((song) =>
      song.Title.toLowerCase().includes(search.toLowerCase())
    );
    setFilteredSongs(filtered);
  }, [search, songs]);

  const handleAddSong = async (songId) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("Token");
      const res = await axios.post(
        "http://localhost:5000/addSongToPlaylist",
        { playlist_id: playlistId, song_id: songId },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setMessage(res.data.message);

      // Redirect back to PlaylistDetails page
      navigate(`/playlist/${playlistId}`);
    } catch (err) {
      setMessage(err.response?.data?.error || "Error adding song");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6">
      <h2 className="text-2xl font-bold mb-6">Add Songs to Playlist</h2>

      <input
        type="text"
        placeholder="Search songs..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="border p-3 w-full mb-6 rounded text-lg"
      />

      <div className="space-y-5">
        {filteredSongs.length > 0 ? (
          filteredSongs.map((song) => (
            <div
              key={song._id}
              className="flex items-center justify-between p-5 border rounded-lg shadow-lg hover:bg-gray-100 transition"
            >
              {/* Left: Cover image */}
              <img
                src={song.Image || "https://via.placeholder.com/80"}
                alt={song.Title}
                className="w-16 h-16 object-cover rounded-lg"
              />

              {/* Middle: Title and Singer */}
              <div className="flex-1 ml-6">
                <h3 className="font-bold text-2xl">{song.Title}</h3>
                <p className="text-gray-500 text-lg">{song.Singer}</p>
              </div>

              {/* Between: Type */}
              <div className="mx-6 text-gray-400 text-lg italic mr-180">{song.Type}</div>

              {/* Right: Add button */}
              <button
                onClick={() => handleAddSong(song._id)}
                disabled={loading}
                className="bg-green-500 text-white px-4 py-1 rounded hover:bg-green-600 transition text-sm"
              >
                {loading ? "Adding..." : "Add"}
              </button>
            </div>
          ))
        ) : (
          <p>No songs found</p>
        )}
      </div>

      {message && <p className="mt-6 text-red-500">{message}</p>}
    </div>
  );
};

export default AddSongOnPlaylistPage;
