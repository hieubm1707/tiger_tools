'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable(
      '{{table_name}}',
      {
        // insert columns here
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
