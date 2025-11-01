// MongoDB initialization script
print('Starting MongoDB initialization...');

// Switch to the application database
db = db.getSiblingDB('multiservice');

// Create a user for the application
db.createUser({
  user: 'app_user',
  pwd: 'app_password123',
  roles: [
    {
      role: 'readWrite',
      db: 'multiservice'
    }
  ]
});

// Create indexes for better performance
db.items.createIndex({ "timestamp": -1 });
db.items.createIndex({ "name": "text" });

// Insert sample data
db.items.insertMany([
  {
    name: "Welcome to Multi-Service App",
    timestamp: new Date(),
    userId: "system"
  },
  {
    name: "Docker Compose Setup Complete",
    timestamp: new Date(),
    userId: "system"
  },
  {
    name: "MongoDB, Redis, and Express API Ready",
    timestamp: new Date(),
    userId: "system"
  }
]);

print('MongoDB initialization completed successfully.');
print('Created database: multiservice');
print('Created user: app_user');
print('Created indexes on items collection');
print('Inserted sample data');

// Show current status
print('Collections in database:');
db.getCollectionNames().forEach(function(collection) {
  print('- ' + collection + ': ' + db[collection].countDocuments() + ' documents');
});