# Prelude

This section contains modules that define global functions and variables used
throughout the config, that provide core functionality used by the rest of the
config.

The following headers are the names of globals defined in these modules.

---

## Events

A flexible event system that serve a different purpose than autocmds, and is
used extensively throughout the config. This is an essential component.

When a responder attached to an event (callback), is called because an actor
fired an event (transmitter), something interesting can happen.

The event has an ID, which can be used to look-up a table of arbitrary data
attached to the event. This table is passed to the callback as an argument,
containing previous state.

The return value of the callback, if a table or function returning a table,
will replace the previous table associated with that event ID; an update.

Why is that interesting? Because when the actor fires the event, it too can
update the table by providing a table *or a function*, accepting a table
as an argument. The existing table will be passed to it, and just like the
callback, it can return a new table used to replace the existing one.

The key point: the actor's function that receives the previous responders'
table, is called BEFORE any responder scheduled for the event being fired
at the moment is called.

In other words, the actor can update the data based on the previous update
by a receiver, then update it before it reaches the current receiver, and
the receiver can then update it for the future actor to receive, again,
updating it and passing it to the future receiver.

```  
                               .                 .
                          .         .       .        .
  
                      @     ||__________*__________||     .
         Transmitter        |-----------------------|        Ping
    ~~~~~~~~~~~~~~~~~~~~~~~~||   Yes. Pong. Ping.  ||~~~~~~~~~~~~~~~~~~~~~~
            Pong            ||   Not. Ping. Pong.  ||       Receiver
  
                                   See Below.
                                       
  
  -----------------------------  Single Receiver  -----------------------------
  
  
     |v----------------------<|
     |> = {} => T = {} => R =^|
     ---------!---------!------
              !         !  Present R receives {} assigned by past T
              !         !   .. R assigns {} for future T
              !
              !  Present T receives {}, assigned by past R
              !   .. assigns {} for future R
  
  
  ---------------------------  Multiple Receivers  ----------------------------
  
       database
       {
         [event_id] ={R3} <----{=}      {v} <----{=}
       }         v         3rd>|R|  2nd>|R|  1st>|R|
                 v             {^} <----{=}      {^}<-------{t}
                 v                                           ^
                 |>-------------------------- > T > fn({R3}) ^
  
  
  -----------------------------------------------------------------------------
```



- Safe
- Debug
