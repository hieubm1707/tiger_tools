import { RequestHandler } from 'express';
import Router from 'express-promise-router';
import { Container } from 'typedi';
import { transformKeysMiddleware, validation } from '../middlewares';
import { {{name.pascalCase()}}Service } from '../services';
import { Create{{name.pascalCase()}}DTO, Filter{{name.pascalCase()}}DTO, {{name.pascalCase()}}, Update{{name.pascalCase()}}DTO } from '../types';

const router = Router();

/**
 * GET /{{name.camelCase()}}
 *
 * Get {{name.camelCase()}} list by filtering
 */
router.get<{}, {{name.pascalCase()}}[], {}, Filter{{name.pascalCase()}}DTO>(
  '/', 
  transformKeysMiddleware as RequestHandler<{}, {{name.pascalCase()}}[], {}, Filter{{name.pascalCase()}}DTO>,
  async (req, res) => {
  const filter = req.query as Filter{{name.pascalCase()}}DTO;

  const {{name.camelCase()}} = await Container.get({{name.pascalCase()}}Service).get{{name.pascalCase()}}(filter);

  res.status(200).json({{name.camelCase()}});
});

/**
 * GET /{{name.camelCase()}}/:{{name.camelCase()}}Id
 *
 * Get {{name.camelCase()}} details
 */
router.get<{ {{name.camelCase()}}Id: string }, {{name.pascalCase()}}>(
  '/:{{name.camelCase()}}Id',
  validation.celebrate({
    params: {
      {{name.camelCase()}}Id: validation.schemas.uuid.required(),
    },
  }),
  async (req, res) => {
    const { {{name.camelCase()}}Id } = req.params;

    const {{name.camelCase()}} = await Container.get({{name.pascalCase()}}Service).get{{name.pascalCase()}}ById({{name.camelCase()}}Id);

    res.status(200).json({{name.camelCase()}});
  },
);

/**
 * POST /{{name.camelCase()}}
 *
 * Create new {{name.camelCase()}}
 */
router.post<{}, {{name.pascalCase()}}, Create{{name.pascalCase()}}DTO>(
  '/',
  validation.celebrate({
    body: validation.create{{name.pascalCase()}}Schema,
  }),
  transformKeysMiddleware,
  async (req, res) => {
    const {{name.camelCase()}}Details = req.body as Create{{name.pascalCase()}}DTO;

    const {{name.camelCase()}} = await Container.get({{name.pascalCase()}}Service).create{{name.pascalCase()}}({{name.camelCase()}}Details);

    res.status(201).json({{name.camelCase()}});
  },
);

/**
 * PUT /{{name.camelCase()}}/:{{name.camelCase()}}Id
 *
 * Update {{name.camelCase()}}
 */
router.put<{ {{name.camelCase()}}Id: string }, {{name.pascalCase()}}, Update{{name.pascalCase()}}DTO>(
  '/:{{name.camelCase()}}Id',
  validation.celebrate({
    params: {
      {{name.camelCase()}}Id: validation.schemas.uuid.required(),
    },
    body: validation.update{{name.pascalCase()}}Schema,
  }),
  transformKeysMiddleware,
  async (req, res) => {
    const { {{name.camelCase()}}Id } = req.params;
    const {{name.camelCase()}}Details = req.body as Update{{name.pascalCase()}}DTO;

    const {{name.camelCase()}} = await Container.get({{name.pascalCase()}}Service).update{{name.pascalCase()}}({{name.camelCase()}}Id, {{name.camelCase()}}Details);

    res.status(200).json({{name.camelCase()}});
  },
);

/**
 * DELETE /{{name.camelCase()}}/:{{name.camelCase()}}Id
 *
 * Delete {{name.camelCase()}}
 *
 */
router.delete<{ {{name.camelCase()}}Id: string }, void>(
  '/:{{name.camelCase()}}Id',
  validation.celebrate({
    params: {
      {{name.camelCase()}}Id: validation.schemas.uuid.required(),
    },
  }),
  async (req, res) => {
    const { {{name.camelCase()}}Id } = req.params;

    await Container.get({{name.pascalCase()}}Service).delete{{name.pascalCase()}}({{name.camelCase()}}Id);

    res.status(200).json();
  },
);

export default router;
