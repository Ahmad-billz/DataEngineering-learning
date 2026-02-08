#!pip install pymongo if not installed
# Connect to MongoDB using PyMongo
from pymongo import MongoClient
import datetime

# Initialize client with connection string
# Uses username 'root', password 'rootpassword', and connects to host.docker.internal:27017

client = MongoClient("mongodb://root:rootpassword@localhost:27017/?authSource=admin")

# Select the 'nosql_db' database
db = client["nosql_db"] # change to the name of the nosql DB that was created by you

# Verify connection by printing database name
print("Connected to database:", db.name)

# List collections to confirm setup (empty if none exist)
print("Collections:", db.list_collection_names())

#==========
#Insertion
# Insert a single document
result = db.users.insert_one({"name": "Frank", "age": 30, "city": "Berlin"})
print("Inserted ID:", result.inserted_id)

# Insert multiple documents
db.users.insert_many([
    {"name": "Grace", "age": 28, "city": "Paris"},
    {"name": "Henry", "age": 35, "city": "Tokyo"}
])

# Verify inserted data
print("Users:")
for doc in db.users.find():
    print(doc)
print('=======')

#========

# Sorting: Find users, sort by age descending
print("Users sorted by age (descending):")
for doc in db.users.find().sort("age"): #.sort("age", -1). for DESC
    print(doc)
print('=======')

#========

# Projection: Find users, return only 'name' field (exclude '_id')
print("User names:")
for doc in db.users.find({}, {"name": 1, "_id": 0}):
    print(doc)
print('=======')

#========

# Filtering: Find users in Berlin or Paris
print("Users in Berlin or Paris:")
for doc in db.users.find({"city": {"$in": ["Berlin", "Paris"]}}):
    print(doc)
print('=======')

#========

# Counting: Count users in Berlin
count = db.users.count_documents({"city": "Berlin"})
print("Number of users in Berlin:", count)
print('=======')

#========

# Delete one user
db.users.delete_one({"name": "Frank"})
print("Deleted Frank")

# Delete multiple users
db.users.delete_many({"city": "Paris"})
print("Deleted users in Paris")

# Verify remaining users
print("Remaining users:")
for doc in db.users.find():
    print(doc)
print('=======')

#========

# Update one user's age
db.users.update_one({"name": "Henry"}, {"$set": {"age": 36}})
print("Updated Henry's age")

# Increment age for all users in Tokyo
db.users.update_many({"city": "Tokyo"}, {"$inc": {"age": 1}})
print("Incremented age for Tokyo users")

# Verify updates
print("Users after updates:")
for doc in db.users.find():
    print(doc)
db.users.drop()
print('=======')

#========

# Timestamping
# Clear previous data
db.events.drop()

# Insert document with timestamp
db.events.insert_one({
    "event": "User signup",
    "timestamp": datetime.datetime.now(),
    "user": "Alice"
})

# Query recent events
print("Events from today:")
for doc in db.events.find({"timestamp": {"$gte": datetime.datetime.now().replace(hour=0, minute=0, second=0)}}):
    print(doc)
db.users.drop()
print('=======')

#========

# Arrays
# Insert user with array
db.users.insert_one({
    "name": "Alice",
    "hobbies": ["coding", "gaming", "reading"]
})

# Query users with specific hobby
print("Users who like coding:")
for doc in db.users.find({"hobbies": "coding"}):
    print(doc)
print('=======')
db.users.drop()

#========

#Embedded Documents
# Insert user with embedded document
db.users.insert_one({
    "name": "Bob",
    "address": {"city": "London", "zip": "SW1A 1AA"}
})

# Query users by city in embedded document
print("Users in London:")
for doc in db.users.find({"address.city": "London"}):
    print(doc)
print('=======')

#========

# Update city in embedded address
db.users.update_one(
    {"name": "Bob"},
    {"$set": {"address.city": "Manchester"}}
)

# Verify update
print("Updated user:")
for doc in db.users.find({"name": "Bob"}):
    print(doc)
print('=======')

#========

#Basic Aggregation
# Clear and insert sample data
db.users.drop()
db.users.insert_many([
    {"name": "Alice", "age": 25, "city": "Berlin"},
    {"name": "Bob", "age": 30, "city": "Berlin"},
    {"name": "Charlie", "age": 35, "city": "Paris"}
])

# Aggregation pipeline: Group by city, calculate average age
pipeline = [
    {"$group": {"_id": "$city", "avg_age": {"$avg": "$age"}}}
]
print("Average age by city:")
for doc in db.users.aggregate(pipeline):
    print(doc)
print('=======')

#========

# Multi-Stage Aggregation
# Pipeline: Filter users over 25, group by city, sort by count
pipeline = [
    {"$match": {"age": {"$gt": 25}}},  # Filter users over 25
    {"$group": {"_id": "$city", "count": {"$sum": 1}}},  # Count users per city
    {"$sort": {"count": -1}}  # Sort by count descending
]
print("Cities with users over 25:")
for doc in db.users.aggregate(pipeline):
    print(doc)
print('=======')

#========

# Drop the 'users' collection if it exists
db.users.drop()
db.events.drop()
# Verify by listing collections (should exclude 'users')
print("Collections after drop:", db.list_collection_names())
