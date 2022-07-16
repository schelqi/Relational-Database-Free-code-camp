#! /bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_MENU()
{
if [[ $1 ]]
then
   echo -e "\n$1"
else
  echo -e "Welcome to My Salon, how can I help you?\n"
fi
#GET ALL SERVICES
SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services")

#PRINT ALL SERVICES
echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo   "$SERVICE_ID) $SERVICE_NAME"
done

#GET SERVICE NUMBRE
read SERVICE_ID_SELECTED

#FIND IF THE SELECTED SERVICE EXISTS
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

#THE SERVICE SELECTED DOESN'T EXIST
if [[ -z $SERVICE_NAME ]]
then
  SERVICE_MENU "I could not find that service. What would you like today?"
#THE SERVICE SELECTED EXIST
else
  echo -e "\nWhat's your phone number?"
  #ASK FOR THE CUSTOMER PHONE NUMBER
  read CUSTOMER_PHONE
  #FIND IF THE CUSTOMER ALREADY EXIST
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #CHECK IF THE CUSTOMER EXIST OR NOT
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  fi

  #ASK FOR THE TIME
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  #SAVE THE APPOINTMENT
  APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED,  '$SERVICE_TIME')")

  #CONFIRM THE APPOINTMENT TO THE USER
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  
  
fi

}
SERVICE_MENU




