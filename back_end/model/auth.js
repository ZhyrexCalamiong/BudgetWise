import mongoose from 'mongoose';

const { Schema } = mongoose;

const UserSchema = new Schema({
    firstName: String,
    middleName: String,
    lastName: String,
    email: String,
    dateOfBirth: String,
    phone: String,
    password: String,
    verified: Boolean,
});

const User = mongoose.model('User', UserSchema);

export default User;
