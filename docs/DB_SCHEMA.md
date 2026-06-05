# СХЕМА БАЗИ ДАНИХ (DB SCHEMA)

## Реєстр

### Колекції (Collections)

#### `users` (Користувачі)
- **Doc ID:** `uid (String)`
- **Поля (Fields):**
    - `id (String)`
    - `phone (String)`
    - `name (String?)`
    - `email (String?)`
    - `photoUrl (String?)`
    - `role (String)`: 'passenger' | 'driver' | 'admin'
    - `isDriver (bool)`
    - `isAdmin (bool)`
    - `fcmToken (String?)`
    - `createdAt (DateTime)`
    - `averageRating (double?)`
    - `numberOfRatings (int?)`

#### `rides` (Поїздки)
- **Doc ID:** `rideId (String)`
- **Поля (Fields):**
    - `id (String)`
    - `riderId (String)`: ID творця (зазвичай водія)
    - `driverId (String?)`: ID водія (якщо відрізняється)
    - `fromLocation (Map)`: `Location`
    - `toLocation (Map)`: `Location`
    - `status (String)`: 'pending', 'active', 'completed', 'cancelled'
    - `pricePerSeat (double)`
    - `seatsAvailable (int)`
    - `departureTime (DateTime)`
    - `createdAt (DateTime)`

#### `bookings` (Бронювання)
- **Doc ID:** `bookingId (String)`
- **Поля (Fields):**
    - `id (String)`
    - `rideId (String)`
    - `passengerId (String)`
    - `seats (int)`
    - `totalPrice (double)`
    - `status (String)`: 'confirmed', 'cancelled'
    - `createdAt (DateTime)`

#### `ratings` (Рейтинги)
- **Doc ID:** `ratingId (String)`
- **Поля (Fields):**
    - `id (String)`
    - `rideId (String)`
    - `raterId (String)`
    - `ratedId (String)`
    - `rating (double)`
    - `comment (String?)`
    - `createdAt (DateTime)`

#### `chats` (Чати)
- **Doc ID:** `chatId (String)` (Зазвичай `uid1_uid2` відсортовані)
- **Поля (Fields):**
    - `id (String)`
    - `participantIds (List<String>)`: [uid1, uid2]
    - `lastMessage (Map)`: `Message`
    - `lastMessageTime (DateTime)`
    - `unreadCount (int)`
- **Підколекції (Sub-collections):**
    - `messages`:
        - **Doc ID:** `messageId (String)`
        - **Поля (Fields):**
            - `id (String)`
            - `senderId (String)`
            - `text (String)`
            - `createdAt (DateTime)`
            - `isRead (bool)`

#### `driver_locations` (Розташування водіїв)
- **Doc ID:** `driverId (String)`
- **Поля (Fields):**
    - `driverId (String)`
    - `latitude (double)`
    - `longitude (double)`
    - `updatedAt (DateTime)`

### Типи (Types)

#### `Location` (Розташування)
- `latitude (double)`
- `longitude (double)`
- `city (String)`
- `address (String?)`

#### `Message` (Повідомлення - Вбудоване)
- `id (String)`
- `senderId (String)`
- `text (String)`
- `createdAt (DateTime)`
- `isRead (bool)`
