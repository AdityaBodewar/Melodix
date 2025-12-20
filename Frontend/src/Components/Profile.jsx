import React, { useEffect, useState } from "react";
import axios from "axios";

const Profile = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState({
    Fullname: "",
    Email: "",
    Username: "",
    Image: "",
  });

  const [imageFile, setImageFile] = useState(null);
  const token = localStorage.getItem("Token");

  useEffect(() => {
    axios
      .get("http://localhost:5000/profile", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((res) => setProfile(res.data))
      .catch((err) => console.log(err));
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setProfile((prev) => ({ ...prev, [name]: value }));
  };

  const handlePhotoChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setImageFile(file);
    const reader = new FileReader();
    reader.onloadend = () => {
      setProfile((prev) => ({ ...prev, Image: reader.result }));
    };
    reader.readAsDataURL(file);
  };

  const saveProfile = async () => {
    try {
      const formData = new FormData();
      formData.append("Fullname", profile.Fullname);
      formData.append("Email", profile.Email);
      formData.append("Username", profile.Username);
      if (imageFile) formData.append("Image", imageFile);

      await axios.put("http://localhost:5000/profile", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      });

      setIsEditing(false);
      setImageFile(null);
      alert("Profile updated successfully!");
    } catch (err) {
      console.error(err);
      alert("Error updating profile");
    }
  };

  const handleLogout = () => {
    localStorage.removeItem("Token");
    localStorage.removeItem("Role");
    window.location.href = "/";
  };

  return (
    <div className="min-h-screen bg-base-200 flex justify-center items-center">
      <div className="w-[360px] bg-base-100 rounded-2xl shadow-xl p-6 space-y-5">

        {/* Profile Image */}
        <div className="flex flex-col items-center gap-3">
          <div className="relative group">
            <img
              src={profile.Image || "https://via.placeholder.com/150"}
              alt="Profile"
              className="w-32 h-32 rounded-full object-cover border-4 border-primary"
            />
            {isEditing && (
              <label className="absolute inset-0 bg-black/50 flex items-center justify-center rounded-full opacity-0 group-hover:opacity-100 cursor-pointer transition">
                <span className="text-white text-sm">Change Photo</span>
                <input
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={handlePhotoChange}
                />
              </label>
            )}
          </div>

          <h2 className="text-xl font-semibold">{profile.Fullname || "Your Name"}</h2>
          <p className="text-sm text-gray-500">@{profile.Username}</p>
        </div>

        {/* Profile Fields */}
        <div className="space-y-3">
          <ProfileField
            label="Full Name"
            name="Fullname"
            value={profile.Fullname}
            isEditing={isEditing}
            onChange={handleChange}
          />

          <ProfileField
            label="Email"
            name="Email"
            value={profile.Email}
            isEditing={isEditing}
            onChange={handleChange}
          />

          <ProfileField
            label="Username"
            name="Username"
            value={profile.Username}
            isEditing={isEditing}
            onChange={handleChange}
          />
        </div>

        {/* Settings Section */}
        <div className="border-t pt-4 space-y-2">
          <h3 className="text-sm font-semibold text-gray-500">Profile Settings</h3>
         
        </div>

        {/* Actions */}
        <div className="space-y-2">
          <button
            onClick={isEditing ? saveProfile : () => setIsEditing(true)}
            className="btn btn-primary w-full"
          >
            {isEditing ? "Save Profile" : "Edit Profile"}
          </button>

          <button
            onClick={handleLogout}
            className="btn btn-outline btn-error w-full"
          >
            Logout
          </button>
        </div>
      </div>
    </div>
  );
};

const ProfileField = ({ label, name, value, isEditing, onChange }) => (
  <div>
    <label className="text-sm text-gray-500">{label}</label>
    {isEditing ? (
      <input
        name={name}
        value={value}
        onChange={onChange}
        className="input input-bordered w-full mt-1"
      />
    ) : (
      <p className="mt-1 font-medium">{value || "-"}</p>
    )}
  </div>
);

export default Profile;
