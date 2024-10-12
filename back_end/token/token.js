import jwt from 'jsonwebtoken';

export const generateToken = (user) => {
    return jwt.sign({ userId: user._id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
};

export const verifyToken = (token) => {
    try {
        return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
        return null;
    }
};

export const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1]; 

    if (!token) return res.sendStatus(401); 

    const decoded = verifyToken(token);
    if (!decoded) return res.sendStatus(403);

    req.user = decoded; 
    next();
};