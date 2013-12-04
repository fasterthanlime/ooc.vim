// all good
if (true)
call()
else
call()

// all good
for (e in list)
call(e)

// all good
while (i > 3)
call(3)

// trickier
if (true) yes()

// trickier
while (i > 3) pull()

// trickier
for (elem in list) add(elem)

// even trickier
if (call())
yes()

// not so tricky
if (call()) {
yes()
} else {
no()
}

// done!
