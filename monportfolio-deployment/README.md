# MonPortfolio Deployment

This repository contains the deployment configuration for the MonPortfolio application on the VPS. It includes the necessary scripts, Docker configurations, and Nginx settings to facilitate the deployment process.

## Project Structure

- **.github/workflows/deploy.yml**: GitHub Actions workflow for automating the deployment process when changes are pushed to the main branch.
- **docker/nginx/sdd.mougnimawash.com.conf**: Nginx configuration for the subdomain `sdd.mougnimawash.com`, handling SSL and proxying requests to the MonPortfolio application.
- **scripts/deploy.sh**: Script to automate the deployment process, including pulling the latest code and restarting services.
- **scripts/rollback.sh**: Script to roll back to the previous version of the application in case of deployment failure.
- **MonPortfolio/src**: Contains the source code for the MonPortfolio application.
- **MonPortfolio/public**: Contains public assets such as HTML, CSS, and JavaScript files.
- **MonPortfolio/package.json**: Configuration file for the MonPortfolio application, listing dependencies and scripts.
- **docker-compose.prod.yml**: Defines production Docker services, networks, and volumes for the MonPortfolio application.
- **.env.production**: Contains environment variables for the production environment.

## Deployment Instructions

1. **Clone the Repository**: Clone this repository to your local machine or server.
2. **Configure Environment Variables**: Update the `.env.production` file with the necessary environment variables for your production setup.
3. **Build and Run Docker Containers**: Use the `docker-compose.prod.yml` file to build and run the application in a containerized environment.
4. **Deploy the Application**: Run the `scripts/deploy.sh` script to deploy the application to the VPS.
5. **Rollback if Necessary**: In case of any issues, use the `scripts/rollback.sh` script to revert to the previous version.

## Additional Information

For more detailed instructions on each step, please refer to the individual script files and the Nginx configuration.