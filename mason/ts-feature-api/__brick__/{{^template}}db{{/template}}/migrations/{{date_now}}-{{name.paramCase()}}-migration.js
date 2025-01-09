'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.sequelize.transaction(async transaction => {
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
      // insert indexes here
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.transaction(async transaction => {
      await transaction.dropTable('{{table_name}}');
    });
  },
};
