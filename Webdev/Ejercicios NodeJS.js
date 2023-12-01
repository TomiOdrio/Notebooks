const {Client} = require("pg");
const EjecutarQuery=async()=>{
    const client = new Client({
        user: "postgres",
        host: "localhost",
        database: "",
        password: "",
        port: 5432,
    });
    await client.connect();
    const res = await client.query("select sexo,count(id_evento_caso) from covid19casos2020 group by sexo");
    const result=res.rows

    await client.end();

    return result
};

EjecutarQuery().then((result)=>{
    console.log(result);
})

// --------------------------------------------------------------------------
// FreeCodeCamp Exercises

// CHAPTER 1

// CHAPTER 2 -> HTML,CSS,JSON,GET AND POST

let express = require('express');
let app = express();
require('dotenv').config();
let bodyParser = require('body-parser');


// #4 CSS AND STATIC FILES
app.use('/public',express.static(__dirname+'/public'));

// #7 MIDDLEWARE FUNCTION
app.use(function middleware(req, res, next) {
  console.log(req.method+" "+req.path+" - "+req.ip);
  next();
});

// #3 LOAD HTML
app.get('/',function(req,res){
  res.sendFile(__dirname+'/views/index.html')
});

// #6 CREATE FUNCTION THAT CHANGES JSON
process.env.MESSAGE_STYLE='uppercase';
app.get('/json',function(req,res){
  if(process.env.MESSAGE_STYLE=='uppercase'){
    res.json({'message':'Hello json'.toUpperCase()});
  } else {
    res.json({'message':'Hello json'})
  };
});

// #8 CHAINED FUNCTIONS: MIDDLEWARE AND HANDLER
app.get('/now',function(req,res,next){
  req.time = new Date().toString();
  next()
},function(req,res){
  res.json({'time':req.time});
})

// #9 GET DATA (1st WAY -> PARAMETERS)
app.get("/:word/echo",function(req, res){
  res.json({echo:req.params.word});
});
// https://boilerplate-express-1.tomasodriozola.repl.co/cualquierPalabra/echo

// #10 GET DATA (2nd WAY -> QUERY)
app.get("/name",function(req, res){
  res.json({name:req.query.first+' '+req.query.last});
});
// https://boilerplate-express-1.tomasodriozola.repl.co/name?first=Tomas&last=Odriozola

// #11 BODYPARSER
app.use(bodyParser.urlencoded({extended: false}));

// #12 POST DATA FROM THE HTML FORM
app.post('/name',function(req,res){
  res.json({name:req.body.first+' '+req.body.last})
})

module.exports = app;

// CHAPTER 3 -> MONGODB

require('dotenv').config();
let mongoose = require('mongoose');

// #1
process.env.MONGO_URI='mongodb+srv://MONGO_USERNAME:MONGO_PASSWORD@cluster0.byte0zp.mongodb.net/MONGO_DATABASE?retryWrites=true&w=majority';
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });

// #2
const personSchema = new mongoose.Schema({
  name:{type:String,required:true},
  age:Number,
  favoriteFoods:[String]
});
let Person = mongoose.model('Person',personSchema);

// #3
let createAndSavePerson = function(done) {
  let tomas = new Person({name: "Tomas Odriozola", age: 20, favoriteFoods: ["eggs", "fish", "fresh fruit"]});

  tomas.save(function(err, data) {
    if(err){console.log(err)}
    else{done(null, data)}
  });
};

// #4
let arrayOfPeople = [{name:'Jane',age:30,favoriteFoods:['Sopa']},{name:'Martin',age:37,favoriteFoods:['Papa']}]
const createManyPeople = (arrayOfPeople, done) => {
  Person.create(arrayOfPeople,function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  });
};

// #5
const findPeopleByName = (personName, done) => {
  Person.find({name:personName},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #6
const findOneByFood = (food, done) => {
  Person.findOne({favoriteFoods:food},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #7
const findPersonById = (personId, done) => {
  Person.findById({_id:personId},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #8
let personId = 10;
const findEditThenSave = (personId, done) => {
  const foodToAdd = "hamburger";
  Person.findById({_id:personId},function(err,data){
    if(err){console.log(err)}
    else{
      data.favoriteFoods.push(foodToAdd);
      data.save((err,updatedPerson) => {
        if(err){console.log(err)}
        else{done(null,updatedPerson)}
      })
    }
  })
};

// #9
const findAndUpdate = (personName, done) => {
  const ageToSet = 20;
  Person.findOneAndUpdate({name:personName},{age:ageToSet},{new: true},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #10
const removeById = (personId, done) => {
  Person.findOneAndRemove({_id:personId},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #11
const removeManyPeople = (done) => {
  const nameToRemove = "Mary";
  Person.remove({name:nameToRemove},function(err,data){
    if(err){console.log(err)}
    else{done(null, data)}
  })
};

// #12
const queryChain = function(done){
  const foodToSearch = "burrito";
  Person.find({favoriteFoods: {$all: [foodToSearch]}})
    .sort({name: 'asc'})
    .limit(2)
    .select('-age')
    .exec(function(err, dataFiltered) {
      if(err){console.log(err)}
      else{done(null, dataFiltered)}
    });
};

// PRÁCTICA FINAL
// #1 --------------------------------------------------------------------------------------------------------------------------------------

// index.js
// where your node app starts

// init project
var express = require('express');
var app = express();

// enable CORS (https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
// so that your API is remotely testable by FCC 
var cors = require('cors');
app.use(cors({optionsSuccessStatus: 200}));  // some legacy browsers choke on 204

// http://expressjs.com/en/starter/static-files.html
app.use(express.static('public'));

// http://expressjs.com/en/starter/basic-routing.html
app.get("/", function (req, res) {
  res.sendFile(__dirname + '/views/index.html');
});


// ejercicio
// CHEQUEA SI LA FECHA EN UTC ES INVÁLIDA

app.get("/api/:date",function(req, res){
  // SI PASA FECHA EN FORMATO FECHA
  let date = new Date(req.params.date);

  // SI ES INVÁLIDA (NO ES UTC), LA PASA A UTC HACIÉNDOLA VÁLIDA EN ESE FORMATO
  if(date.toUTCString() === "Invalid Date"){
    date = new Date(+req.params.date);
  }

  // SI SIGUE SIENDO INVÁLIDA ES QUE ES UN FORMATO INCORRECTO
  if(isInvalidDate(date)){
    res.json({'error':'Invalid Date'});
    return
  }  

  // DEVUELVE LOS RESULTADOS PARA LA FECHA
  res.json({
    'unix':date.getTime(),
    'utc':date.toUTCString()
  });
});

// SI NO SE LE PASA NINGUNA FECHA, TRABAJA CON LA FECHA ACTUAL
app.get("/api",function(req, res){
  let date = new Date();
  res.json({
    'unix':date.getTime(),
    'utc':date.toUTCString()
  });
});


// listen for requests :)
var listener = app.listen(process.env.PORT, function () {
  console.log('Your app is listening on port ' + listener.address().port);
});


// #2 -----------------------------------------------------------------------------------------------------------------------------------

app.get('/api/whoami', function (req, res) {
  res.json({
    'ipaddress':req.socket.remoteAddress,
    'language':req.headers['accept-language'],
    'software':req.headers['user-agent']
  });
});

// #3 -----------------------------------------------------------------------------------------------------------------------------------

app.use(express.urlencoded({extended:true})); //es necesario para poder hacer el req.body.

const urlsCompletas = [];
const urlsCortas = [];

app.post('/api/shorturl', function(req, res) {
  const url = req.body.url;
  let indexUrl = urlsCompletas.indexOf(url);

  if(!url.includes('https://') && !url.includes('http://')){
    return res.json({error: 'Invalid url'})
  }
  
  if(indexUrl < 0){
    urlsCompletas.push(url);
    urlsCortas.push(urlsCompletas.length.toString());
    indexUrl = urlsCompletas.indexOf(url);
  }

  return res.json({
      original_url: url,
      short_url: urlsCortas[indexUrl]
  })
});

app.get('/api/shorturl/:short', function(req, res) {
  const urlCorta = req.params.short.toString();
  let indexUrlCorta = urlsCortas.indexOf(urlCorta);

  if(indexUrlCorta<0){
    return res.json({
      error: 'Invalid url',
    })
  }else{
    res.redirect(urlsCompletas[indexUrlCorta])
  }
});

// #4 -----------------------------------------------------------------------------------------------------------------------------------

const express = require('express');
const app = express();
const cors = require('cors');
require('dotenv').config();
const mongoose = require('mongoose');
const {Schema} = mongoose;

mongoose.connect(process.env['MONGO_URI'])

const userSchema = new Schema({
  username: String,
});

const exerciseSchema = new Schema({
  username: {type: String, required:true},
  description: String,
  duration: Number,
  date: Date,
  user_id:String
});

const User = mongoose.model('User',userSchema);
const Exercise = mongoose.model('Exercise',exerciseSchema);

app.use(cors())
app.use(express.urlencoded({extended:true})); //es necesario para poder hacer el req.body.username
app.use(express.static('public'))
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html')
});

app.post('/api/users', async(req,res) => {
  const userObj = new User({
    username: req.body.username
  })

  try{
    const user = await userObj.save();
    console.log(user);
    res.json(user);
  }catch(err){
    console.log(err);
  }
});


app.get('/api/users', async(req,res) => {
  const users = await User.find({}).select('_id username');
  if(!users){
    res.send('No hay usuarios');
  }else{
    res.json(users);
  }
})

app.post('/api/users/:_id/exercises', async(req,res) => {
  const id = req.params._id;
  const {description,duration,date} = req.body;

  try{
    const user = await User.findById(id);
    if(!user){
      res.send('No hay un usuario con ese id');
    }else{
      const exerciseObj = new Exercise({
        user_id:user._id, 
        username:user.username,
        description,
        duration,
        date: date ? new Date(date) : new Date()
        //si le pasan date, la convierte en tipo Date. Si no le pasan fecha, pone la fecha actual en formato date.
      })
      const exercise = await exerciseObj.save();
      res.json({
        _id:user._id, 
        username:user.username,
        description: exercise.description,
        duration: exercise.duration,
        date: new Date(exercise.date).toDateString()
      });
    }
  }catch(err){
    console.log(err);
    res.send('Hubo un error')
  }
});

app.get('/api/users/:_id/logs', async(req,res) => {
  const {from,to,limit} = req.query;
  const id = req.params._id;
  const user = await User.findById(id);
  if(!user){
    res.send('No se encontró ningun usuario');
    return;
  }
  let dateObj = {}
  if(from){
    dateObj["$gte"] = new Date(from)
  }
  if(to){
    dateObj["$lte"] = new Date(to)
  }
  let filter = {user_id:id}

  if(from || to){
    filter.date = dateObj;
  }
  const exercises = await Exercise.find(filter).limit(+limit ?? 500)

  const log = exercises.map(e => ({
    description: e.description,
    duration: e.duration,
    date: e.date.toDateString()
  }))

  res.json({
    username: user.username,
    count: exercises.length,
    _id: user._id,
    log
  })
})

const listener = app.listen(process.env.PORT || 3000, () => {
  console.log('Your app is listening on port ' + listener.address().port)
})

// #5 -----------------------------------------------------------------------------------------------------------------------------------

const multer = require('multer');

// resto de configuración inicial

const upload = multer({dest:'./public/date/uploads'})

app.get('/', function (req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

//upfile es el name del input de archivos del html
app.post('/api/fileanalyse',upload.single('upfile'),function(req,res){
  const {originalname,mimetype,size} = req.file
  res.json({
    name:originalname,
    type:mimetype,
    size
  })
})
