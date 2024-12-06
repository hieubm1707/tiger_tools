import Joi from '@hapi/joi';
import { celebrate } from 'celebrate';

// Declare here custom validation schemas
const schemas = {
  id: Joi.number().integer().positive(),
  uuid: Joi.string().guid(),
  string: Joi.string().trim(),
  boolean: Joi.boolean(),
  date: Joi.date(),
  number: Joi.number(),
  array: Joi.array(),
  object: Joi.object(),
};

export { celebrate, Joi, schemas };
