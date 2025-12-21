import React, { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const CreatePlaylist = () => {
  const [playlists, setPlaylists] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [newPlaylistName, setNewPlaylistName] = useState("");
  const navigate = useNavigate();
  const token = localStorage.getItem("Token");
 
  useEffect(() => {
    fetchPlaylists();
  }, []);


  const fetchPlaylists = async () => {
   
    if(!token){
      return ;
    }

    try {
      
      const res = await axios.get("https://melodix-1.onrender.com/myPlaylists", {
        headers: { Authorization: `Bearer ${token}` },
      });
      setPlaylists(res.data.playlists);
    } catch (err) {
      setMessage("Error fetching playlists");
    }
  };

  const handleCreatePlaylist = async () => {
    if (!newPlaylistName) {
      setMessage("Playlist name is required");
      return;
    }
    setLoading(true);
    setMessage("");
    try {
      const res = await axios.post(
        "https://melodix-1.onrender.com/createPlaylist",
        { playlist_name: newPlaylistName },
        { headers: { Authorization: `Bearer ${token}` } }
      );

      setMessage(res.data.message);
      setNewPlaylistName("");
      setShowModal(false);

      
      navigate(`/playlist/${res.data.playlist_id}`);

      fetchPlaylists();
    } catch (err) {
      setMessage(err.response?.data?.error || "Error creating playlist");
    } finally {
      setLoading(false);
    }
  };

  const handleAddPlaylistClick = () => {
  if (!token) {
    alert("You need to login first");
    navigate("/login");
    return;
  }
  setShowModal(true);
};


  return (
    <div className="p-4">
      <div className="flex flex-col lg:justify-between items-start lg:items-center mb-4  ">
        <button
         onClick={handleAddPlaylistClick}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition absolute z-40 "
        >
          Add Playlist
        </button>
        <h2 className="text-xl font-bold mt-13 absolute lg:relative z-30 ">Your Playlists</h2>
      </div>

      <div className="
    flex flex-row gap-4
    overflow-x-auto whitespace-nowrap
    lg:flex-col lg:overflow-y-auto lg:overflow-x-hidden
    mt-30 lg:mt-0
   ">
        {playlists.length > 0 ? (
          playlists.map((pl) => (
            <div
              key={pl.playlist_id}
              onClick={() => navigate(`/playlist/${pl.playlist_id}`)}
              className= "border rounded-full w-20 h-20 flex-shrink-0 items-center p-4 shadow cursor-pointer  ml-2 lg:ml-0    hover:bg-gray-200 transition "            >
              <h3 className="font-bold text-[13px]">{pl.playlist_name}</h3>
            </div>
          ))
        ) : (
          <p>No playlists found</p>
        )}
      </div>
      {showModal && (
        <div className="fixed inset-0 flex items-center justify-center   bg-base-200 z-50">
          <div className=" p-6 rounded shadow w-96">
            <h2 className="text-lg font-bold mb-2">Create Playlist</h2>
            <input
              type="text"
              placeholder="Playlist Name"
              value={newPlaylistName}
              onChange={(e) => setNewPlaylistName(e.target.value)}
              className="border p-2 w-full mb-4"
            />
            <div className="flex justify-end space-x-2">
              <button
                onClick={() => setShowModal(false)}
                className="px-4 py-2 rounded hover:bg-gray-400 transition"
              >
                Cancel
              </button>
              <button
                onClick={handleCreatePlaylist}
                disabled={loading}
                className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition"
              >
                {loading ? "Creating..." : "Create"}
              </button>
            </div>
            {message && <p className="mt-2 text-red-500">{message}</p>}
          </div>
        </div>
      )}
    </div>
  );
};

export default CreatePlaylist;
