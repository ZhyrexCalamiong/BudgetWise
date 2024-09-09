import mongoose from 'mongoose';

const { Schema } = mongoose;

const UserSchema = new Schema({
    name: String,
    email: String,
    DateOfBirth: Date,
    Phone: String,
    password: String,
    verified: Boolean,
});

const User = mongoose.model('User', UserSchema);

export default User;
