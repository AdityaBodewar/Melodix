import React, { useState } from 'react';
import axios from 'axios';

const AddSongForm = () => {

  const [formData, setFormData] = useState({
    title: "",
    singer: "",
    type: "",
    language: "",
  });

  const [image, setImage] = useState(null);
  const [audio, setAudio] = useState(null);

  const submitHandler = async () => {
    const data = new FormData();
    data.append("title", formData.title);
    data.append("singer", formData.singer);
    data.append("type", formData.type);
    data.append("language", formData.language);
    data.append("image", image);
    data.append("audio", audio);

    try {
      await axios.post("http://localhost:5000/api/songs", data, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      alert("Song uploaded successfully!");

    } catch (error) {
      console.error(error);
      alert("Failed to upload song!");
    }
  };

  return (
    <div className="min-h-screen bg-[#121212] flex justify-center items-center p-6">
      <div className="bg-[#181818] p-8 rounded-xl shadow-lg w-full max-w-lg">

        <h1 className="text-2xl font-bold text-white mb-6 text-center">
          Upload New Song
        </h1>

        <input
          type="text"
          placeholder="Song Title"
          className="w-full p-3 mb-4 bg-[#282828] text-white rounded-lg focus:ring-2 focus:ring-green-500"
          onChange={e => setFormData({ ...formData, title: e.target.value })}
        />

        <input
          type="text"
          placeholder="Singer Name"
          className="w-full p-3 mb-4 bg-[#282828] text-white rounded-lg focus:ring-2 focus:ring-green-500"
          onChange={e => setFormData({ ...formData, singer: e.target.value })}
        />

        <input
          type="text"
          placeholder="Type (Sad, Romantic, Phonk...)"
          className="w-full p-3 mb-4 bg-[#282828] text-white rounded-lg focus:ring-2 focus:ring-green-500"
          onChange={e => setFormData({ ...formData, type: e.target.value })}
        />

        <input
          type="text"
          placeholder="Language"
          className="w-full p-3 mb-4 bg-[#282828] text-white rounded-lg focus:ring-2 focus:ring-green-500"
          onChange={e => setFormData({ ...formData, language: e.target.value })}
        />

        <label className="text-gray-300 mb-2 block">Cover Image</label>
        <input
          type="file"
          accept="image/*"
          className="w-full p-2 mb-4 bg-[#282828] text-gray-300 rounded-lg cursor-pointer"
          onChange={e => setImage(e.target.files[0])}
        />

        <label className="text-gray-300 mb-2 block">Audio File</label>
        <input
          type="file"
          accept="audio/*"
          className="w-full p-2 mb-6 bg-[#282828] text-gray-300 rounded-lg cursor-pointer"
          onChange={e => setAudio(e.target.files[0])}
        />

        <button
          onClick={submitHandler}
          className="w-full bg-green-500 hover:bg-green-600 text-white font-semibold p-3 rounded-lg transition"
        >
          Upload Song
        </button>

      </div>
    </div>
  );
};

export default AddSongForm;
