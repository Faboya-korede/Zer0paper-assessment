#Base Image node:14
FROM node:14
#Set working directory to /app
WORKDIR /app
#Set PATH /app/node_modules/.bin
ENV PATH /app/node_modules/.bin:$PATH
#Copy package.json in the image
COPY package.json ./

#Install Packages
RUN npm install
RUN npm install express --save
#RUN npm install mysql --save

#Copy the app
COPY . ./
#Expose application port
EXPOSE 5555

#Start the app
CMD ["node", "app.js"]

