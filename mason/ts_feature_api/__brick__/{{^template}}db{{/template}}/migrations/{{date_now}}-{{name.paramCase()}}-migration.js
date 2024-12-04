'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable(
      '{{table_name}}',
      {
        // insert columns here
        id: {
          type: Sequelize.UUID,
          primaryKey: true,
          allowNull: false,
          defaultValue: Sequelize.UUIDV4,
          field: 'id',
          comment: 'ID of the {{name.camelCase()}}',
        },
        title: {
          type: Sequelize.TEXT,
          allowNull: false,
          field: 'title',
          comment: 'Title of the {{name.camelCase()}}',
        },
        description: {
          type: Sequelize.TEXT,
          allowNull: true,
          field: 'description',
          comment: 'Description of the {{name.camelCase()}}',
        },
        createdAt: {
          type: Sequelize.DATE,
          allowNull: false,
          field: 'created_at',
          comment: "Date and time of the {{name.camelCase()}}'s creation date",
        },
        updatedAt: {
          type: Sequelize.DATE,
          allowNull: true,
          field: 'updated_at',
          comment: "Date and time of the {{name.camelCase()}}'s last update",
        },
      },
      {
        charset: 'utf8',
        collate: 'utf8_general_ci',
      },
    );
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable('{{table_name}}');
  },
};
