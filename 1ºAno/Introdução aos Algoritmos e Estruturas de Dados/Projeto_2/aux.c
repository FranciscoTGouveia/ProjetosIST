#include "commands.h"

unsigned int hash(char *res_code, int hash_size) {
    /* Hash function that uses the reservation code to generate a key */
    int h, a = 31415, b = 27183;
    for (h = 0; *res_code != '\0'; res_code++, a = a * b % (hash_size - 1))
        h = (a * h + *res_code) % hash_size;
    return h;
}

void create_ht_item(char *res_code, Hash_Table *htable, Reservation *res) {
    /* Create a hash table item and populate it with a pointer to a
    reservation (which points to the linked list associated with a flight) */
    HT_Item *item = (HT_Item *)malloc(sizeof(HT_Item));
    int hash_index = hash(res_code, htable->size);
    while (htable->items[hash_index] != NULL && hash_index < htable->size) {
        hash_index += 7;
    }
    item->key = res_code;
    item->res = res;
    htable->items[hash_index] = item;
    (htable->count)++;
}

Hash_Table *create_hash_table(int size) {
    /* Create a hash_table with a static size */
    Hash_Table *table = (Hash_Table *)malloc(sizeof(Hash_Table));
    table->size = size;
    table->count = 0;
    table->items = (HT_Item **)calloc(table->size, sizeof(HT_Item *));
    return table;
}

Reservation *ht_search(Hash_Table *htable, char *res_code) {
    /* Search for a reservation with the reservation code */
    unsigned int ht_index = hash(res_code, htable->size);
    HT_Item *item = htable->items[ht_index];
    if (item != NULL) {
        if (strcmp(item->key, res_code) == 0) return item->res;
    }
    return NULL;
}

void delete_ht_item(Hash_Table *htable, char *res_code) {
    /* Delete a item from the hash table with the reservation code */
    int ht_index = hash(res_code, htable->size);
    free(htable->items[ht_index]);
}

void destroy_hash_table(Hash_Table *my_ht) {
    /* Iterate over all the hash table items and free them */
    int i;
    for (i = 0; i < my_ht->size; i++) {
        if (my_ht->items[i] != NULL) free(my_ht->items[i]);
    }
    free(my_ht->items);
    free(my_ht);
}
