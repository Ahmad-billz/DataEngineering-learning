from pymongo import MongoClient
from bson.objectid import ObjectId
from pymongo.read_preferences import ReadPreference
from pymongo.write_concern import WriteConcern


client = MongoClient("mongodb://root:rootpassword@localhost:27017/?authSource=admin")
db = client["nosql_db"] # change to the name of the nosql DB that was created by you

db.users.drop()
#Create
firstUser = db.users.insert_one({"name": "Frank", "age": 30, "city": "Berlin"})
firstUserID = firstUser.inserted_id
print(f"Inserted ID: {firstUserID}")

#Read
for user in db.users.find({"city": "Berlin"}, {"name": 1, "_id": 0}).sort("age", -1):
    print(user)

#Update
db.users.update_many({"age": {"$gt": 25}}, {"$set": {"status": "active"}})

#Delete
db.users.delete_one({"name": "Frank"})

#Find with Id
print('with Object ID')
user = db.users.find_one({"_id": ObjectId(firstUserID)})
print(user)

#Write Concerns
print('Write Concerns ')
db.users.with_options(write_concern=WriteConcern(w=1, wtimeout=1000)).insert_one({"name": "Grace"}) 

#Read Preferences 
print('Read Preferences ')
for user in db.users.with_options(read_preference=ReadPreference.SECONDARY_PREFERRED).find():
    print(user)