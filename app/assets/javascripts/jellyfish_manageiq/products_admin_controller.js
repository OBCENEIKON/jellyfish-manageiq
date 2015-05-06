'use strict';

/**@ngInject*/
function ProductsAdminController(categories, categoriesByName, categoryNames, clouds) {
  this.categoriesByName = categoriesByName;
  this.categories = categories;
  this.categoryNames = categoryNames;
  this.clouds = clouds;

  // TODO: Where are images stored and retrieved from?
  this.productImages = [
    'products/aws_ec2.png',
    'products/aws_rds.png',
    'products/aws_s3.png',
    'products/redhat.png',
    'products/ubuntu.png',
    'products/jira.png',
    'products/windows.png',
    'products/exchange.png',
    'products/confluence.png',
    'products/php.png',
    'products/java.png',
    'products/rails.png',
    'products/apache.png',
    'products/database.png',
    'products/postgresql.png',
    'products/dna.png',
    'products/hadoop.png',
    'products/kb.png',
    'products/teradata.png',
    'products/mssql.png',
    'products/bugzilla.png',
    'products/oracle.png',
    'products/netapp.png',
    'products/firewall.png',
    'products/f5.png',
    'products/man.png',
    'products/woman.png',
    'products/mean.png',
  ];
}

ProductsAdminController.resolve = {
  /**@ngInject*/
  categories: function(ProductTypesResource) {
    return ProductTypesResource.query().$promise;
  },
  /**@ngInject*/
  categoriesByName: function(categories) {
    return _.object(_.map(categories, function(x){return [x.title, x]}))
  },
  /**@ngInject*/
  categoryNames: function(categories) {
    return _.map(categories, "title");
  },
  /**@ngInject*/
  clouds: function(CloudsResource) {
    return CloudsResource.query().$promise;
  }

};

window.ProductsAdminController = ProductsAdminController;
