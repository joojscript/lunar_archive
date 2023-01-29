import { MongoMemoryReplSet } from 'mongodb-memory-server';

let mongod: MongoMemoryReplSet;

beforeAll(async () => {
  mongod = await MongoMemoryReplSet.create({
    replSet: {
      dbName: 'test',
      storageEngine: 'wiredTiger',
    },
  });
  const uri = await mongod.getUri('test');
  process.env.DATABASE_URL = uri;
});

afterAll(async () => {
  await mongod.stop();
});
