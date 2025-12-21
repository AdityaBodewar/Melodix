import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import MiniPlayer from "./MiniPlayer";
import { useAudio } from "../ContextProvider/AudioContext";

const PlaylistDetails = () => {
  const { playlistId } = useParams();
  const [playlist, setPlaylist] = useState(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [currentSong, setCurrentSong] = useState(null);
  const navigate = useNavigate();

  const { playSong } = useAudio();

  useEffect(() => {
    const fetchPlaylistDetails = async () => {
      try {
        const token = localStorage.getItem("Token");
        const res = await axios.get(
          `https://melodix-1.onrender.com/playlist/${playlistId}`,
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setPlaylist(res.data.playlist);
      } catch (err) {
        setMessage(err.response?.data?.error || "Error fetching playlist");
      } finally {
        setLoading(false);
      }
    };
    fetchPlaylistDetails();
  }, [playlistId]);

  if (loading) return <p className="p-4 sm:p-0">Loading...</p>;
  if (!playlist) return <p className="p-4 sm:p-0">{message || "Playlist not found"}</p>;

  return (
    <div className="p-3 sm:p-6">
      {/* Header */}
      <div className="flex justify-between items-center mb-4 sm:mb-6">
        <h2 className="text-lg sm:text-2xl font-bold truncate sm:truncate-none">
          {playlist.playlist_name}
        </h2>

        <button
          onClick={() => navigate(`/playlist/${playlistId}/add`)}
          className="bg-blue-500 text-white
                     px-3 py-1.5 text-sm
                     sm:px-4 sm:py-2 sm:text-base
                     rounded hover:bg-blue-600 transition"
        >
          + Add Songs
        </button>
      </div>

      {/* Songs */}
      <div className="space-y-3 sm:space-y-5">
        {playlist.songs && playlist.songs.length > 0 ? (
          playlist.songs.map((song) => (
            <div
              key={song._id}
              className="flex items-center justify-between
                         p-3 sm:p-5
                         border rounded-lg shadow-lg
                         hover:bg-gray-100 transition cursor-pointer"
              onClick={() => {
                setCurrentSong(song);
                playSong(song);
              }}
            >
              {/* Image */}
              <img
                src={song.Image || "https://via.placeholder.com/80"}
                alt={song.Title}
                className="w-12 h-12 sm:w-16 sm:h-16 object-cover rounded-lg"
              />

              {/* Title & Singer */}
              <div className="flex-1 ml-3 sm:ml-6">
                <h3 className="font-bold text-lg sm:text-2xl truncate sm:truncate-none">
                  {song.Title}
                </h3>
                <p className="text-gray-500 text-sm sm:text-lg truncate sm:truncate-none">
                  {song.Singer}
                </p>
              </div>

              {/* Type */}
              {song.Type && (
                <div className="hidden sm:block mx-6 text-gray-400 text-lg italic">
                  {song.Type}
                </div>
              )}
            </div>
          ))
        ) : (
          <p className="text-sm sm:text-base">No songs in this playlist yet</p>
        )}
      </div>

      {/* Mini Player */}
      <MiniPlayer song={currentSong} />
    </div>
  );
};

export default PlaylistDetails;
