var mysql = require('mysql');
var pool = mysql.createPool({
	connectionLimit : 10,
	host		    : 'classmysql.engr.oregonstate.edu',
	user			: 'cs340_johnsaar',
	password		: '0710',
	database		: 'cs340_johnsaar'
});
module.exports.pool = pool;