module.exports = (mongoose) ->

  Schema = mongoose.Schema
  ObjectId = Schema.ObjectId

  lawyerSchema = new Schema
    firstName: String
    middleName: String
    lastName: String
    called: String

  sanSchema = new Schema
    lawyer: ObjectId

  models =
    Lawyer: mongoose.model "Lawyer", lawyerSchema
    San: mongoose.model "San", sanSchema

  models