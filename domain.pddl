(define (domain build)
  (:requirements :strips)
  (:types person container item location category permissions)

  (:constants
    everyone - permissions
  )


  (:predicates
    (person_hands_empty ?person - person)
    (at ?holder - (either person container) ?item - item)
    (item_has_type ?item - item ?cat - category)
    (permission_to_take ?perms - permissions ?cat - category)
    (has_permissions ?person - person  ?perms - permissions)
    (is_transferrable ?perms - permissions)
    (allowed_to_take ?person - person ?cat - category)
    (adjacent ?a - location ?b - location)
    (large_at ?where - location ?holder - (either container person))
    (permission_to_walk ?perms - permissions ?loc - location)
    
    (is_toggleable ?item - item)
    (toggled_on ?item - item)
    (permission_to_toggle ?perms - permissions ?item - item)
  )
  
  (:action take_into_hands :parameters(
        ?who - person
        ?what - item
        ?cat - category
        ?box - container
        ?perms - permissions
        ?loc - location
        )
   :precondition (and
        (large_at ?loc ?box)
        (large_at ?loc ?who)

        (person_hands_empty ?who)

        (at ?box ?what)

        (item_has_type ?what ?cat)
        (permission_to_take ?perms ?cat)
        (has_permissions ?who ?perms)
  )                    
   :effect (and 
            (not (at ?box ?what))
            (not (person_hands_empty ?who))
            (at ?who ?what)
        )
  )
  
  (:action put_from_hands
    ; if person P1 and container C are in the same location L, and person holds item I, then person no longer holds item I and container holds item I
    :parameters (
    ?person - person
    ?item - item
    ?box - container
    ?loc - location
    )
    :precondition (and
        (at ?person ?item)
        (not (person_hands_empty ?person))
        (large_at ?loc ?person)
        (large_at ?loc ?box)
    )
    :effect (and
        (person_hands_empty ?person)
        (not (at ?person ?item))
        (at ?box ?item)
    )
  )
  
  (:action go-to-room
    ; TODO: if P is in A, and adjacent A and B, and walking on B requires permission Q, and P has permission Q, then P is in B 
    :parameters(
    ?person - person
    ?a - location
    ?b - location
    ?perms - permissions
    )
    :precondition( and
    (large_at ?a ?person)
    (adjacent ?a ?b)
    (permission_to_walk ?perms ?b)
    (has_permissions ?person ?perms)
    
    )
    :effect( and 
    (not(large_at ?a ?person))
    (large_at ?b ?person)
    )
  )
  (:action give-to-person
    ; TODO: if P1 and P2 is in the same location L, and P1 holds item I, and item I has category C, and holding category C 
    ;requires permission Q, and P2 has permission Q, then P1 doesn't hold the item and P2 holds the item.
    :parameters(
    ?p1 - person
    ?p2 - person
    ?loc - location
    ?item - item
    ?cat - category
    ?perms - permissions
    )
    :precondition(and
    (large_at ?loc ?p1)
    (large_at ?loc ?p2)
    (at ?p1 ?item)
    (not(person_hands_empty ?p1))
    (person_hands_empty ?p2)
    (item_has_type ?item ?cat)
    (permission_to_take ?perms ?cat)
    (has_permissions ?p2 ?perms)
    (allowed_to_take ?p2 ?cat)
    
    )
    :effect(and
    (person_hands_empty ?p1)
    (not (at ?p1 ?item))
    (at ?p2 ?item)
    (not(person_hands_empty ?p2))
    
    )
  )
  (:action grant-permission
    ; TODO: if P1 and P2 are in the same location L, and P1 has permission Q, and permission Q is transferrable, then P2 now has permission Q.
    :parameters(
    ?p1 - person
    ?p2 - person
    ?loc - location
    ?perms - permissions
    )
    :precondition(and
    (large_at ?loc ?p1)
    (large_at ?loc ?p2)
    (has_permissions ?p1 ?perms)
    (is_transferrable ?perms)
    )
    :effect(and
;    (not (has_permissions ?p1 ?perms))
    (has_permissions ?p2 ?perms)
    
    )
  )
  (:action toggle_item_on
    ; TODO: if P1 holds item I, and item I is toggleable, and item I is toggled off, 
    ;and toggling item I requires permission Q, and P1 has permission Q, then item I is now toggled on
    :parameters(
    ?p1 -person
    ?item - item
    ?perms - permissions
    )
    :precondition(and
    (at ?p1 ?item)
    (is_toggleable ?item)
    (not(toggled_on ?item))
    (has_permissions ?p1 ?perms)
    (permission_to_toggle ?perms ?item)
    )
    :effect(
    toggled_on ?item
    )
  )
  (:action toggle_item_off
    ; TODO: if P1 holds item I, and item I is toggleable, and item I is toggled on,
    ;and toggling item I requires permission Q, and P1 has permission Q, then item I is now toggled off
    :parameters(
    ?p1 -person
    ?item - item
    ?perms - permissions
    )
    :precondition(and
    (at ?p1 ?item)
    (is_toggleable ?item)
    (toggled_on ?item)
    (has_permissions ?p1 ?perms)
    (permission_to_toggle ?perms ?item)
    )
    :effect(
    not(toggled_on ?item)
    )
  )

)
