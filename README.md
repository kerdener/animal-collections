### Animal groups

The word "colony" can be used to describe a group of ants – "a colony of ants" – but can also be used to describe badgers, bats, beavers, rabbits (and a few others). This data projects makes it easy to explore this weird world of names using a graph.

The `generate-cypher.sh` script will create a set of Cypher queries which can be used to populate a graph with 300+ "animal" and "group" combinations.

The file `input.txt` contains inputs such as "albatross flock", which would result in the following Cypher:

    MERGE(:Animals {name:'albatross'});

    MERGE(:Group {name:'flock'});

    MATCH(a:Animals {name:'albatross'})
    MATCH(g:Group {name:'flock'})
    MERGE (g) -[:OF]-> (a);

### Steps to populate local Neo4j

Run the following commands to populate Neo4j with the various animal collections:
 
    % cd animal-collections
    % ./generate-cypher.sh > cypher.txt
    % cat cypher.txt | /path/to/neo4j/bin/cypher-shell

Or combine them like this:

    % ./generate-cypher.sh | /path/to/neo4j/bin/cypher-shell

### Queries to explore the data


* find all groups with two (or more) animal types

    ```
    MATCH (g:Group) -[r]-> (a:Animals)
    WITH g, count(a) as animals
    WHERE animals >= 2
    RETURN g
    ```

* find all groups+animals with two (or more) animal types
    ```
    MATCH (g:Group) -[r]-> (a:Animals)
    WITH g, count(a) as animals
    WHERE animals >= 2
    UNWIND g AS group
    MATCH (g2:Group {name: group.name}) -- (a2:Animals)
    RETURN g2,a2
    ```

* list all group names, show associated animals

    ```
    MATCH (g:Group) -[r]-> (a:Animals)
    WITH g, a, count(a) as animals
    RETURN distinct(g.name) as group, collect(a.name) as animals
    ORDER BY g.name
    ```

* list all animal names, show associated groups

    ```
    MATCH (g:Group) -[r]-> (a:Animals)
    WITH g, a, count(a) as animals
    RETURN distinct(a.name) as group, collect(g.name) as groups
    ORDER BY a.name
    ```


### References

The following websites were used as input sources:
* https://en.wikipedia.org/wiki/List_of_animal_names
* https://www.theanimalfacts.com/glossary/animal-group-names/
* https://owlcation.com/stem/collective-names-for-groups-of-animals

